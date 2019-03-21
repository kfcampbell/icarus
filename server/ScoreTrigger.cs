using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Linq;
using PlayFab;
using PlayFab.ClientModels;
using PlayFab.ServerModels;

// todo(kcampbell):
// 0. create method to set highest_toss user statistic
// 2. create models on clientside
// 3. update clientside requests
// 4. test test test test

namespace Icarus
{
    public static class ScoreTrigger
    {
        [FunctionName("ScoreTrigger")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            log.LogInformation($"request body: {requestBody}");
            //Score score = JsonConvert.DeserializeObject<Score>(requestBody);

            // post request. add to leaderboard
            PlayFab.PlayFabSettings.DeveloperSecretKey = Environment.GetEnvironmentVariable("PLAYFAB_DEVELOPER_SECRET_KEY");
            PlayFab.PlayFabSettings.TitleId = "6D64";
            if (requestBody != null && requestBody != string.Empty)
            {
                var sendHighScore = await PlayFab.PlayFabServerAPI.UpdatePlayerStatisticsAsync(
                    new PlayFab.ServerModels.UpdatePlayerStatisticsRequest
                    {
                        PlayFabId = "", // comes from login
                        Statistics = new List<PlayFab.ServerModels.StatisticUpdate>()
                        {
                            new PlayFab.ServerModels.StatisticUpdate()
                            {
                                StatisticName = "highest_toss",
                                Value = 525
                            }
                        }
                    }
                );
                return (ActionResult)new OkObjectResult($"{JsonConvert.SerializeObject(sendHighScore)}");
            }
            // get request. get all scores
            else
            {
                var leaderboard = await PlayFab.PlayFabServerAPI.GetLeaderboardAsync(
                    new PlayFab.ServerModels.GetLeaderboardRequest
                    {
                        StartPosition = 0,
                        MaxResultsCount = 100,
                        StatisticName = "highest_toss",
                    }
                );
                return (ActionResult) new OkObjectResult(JsonConvert.SerializeObject(leaderboard));
            }
        }
    }
}
