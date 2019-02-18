using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Linq;

// todo(kcampbell):
// 3. input validation

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
            Score score = JsonConvert.DeserializeObject<Score>(requestBody);

            if (score != null)
            {
                using (var db = new ScoreContext())
                {
                    db.Scores.Add(score);

                    var count = await db.SaveChangesAsync();
                    log.LogInformation($"{count} records written to DB");
                }
                return (ActionResult)new OkObjectResult("Successfully added high score to database");
            }
            else
            {
                using (var db = new ScoreContext())
                {
                    var allScores = db.Scores.OrderByDescending(s => (s.PeakAltitude - s.BaselineAltitude)).ToList();
                    return (ActionResult)new OkObjectResult(allScores);
                }
            }
        }
    }
}
