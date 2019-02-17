using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

// plan: have only one endpoint/route for now
// eventually may need to expand to multiple functions and function proxies
// if get, return list of high scores (could do region by parameter (city, zip, county, etc.))
// if post, add a single high score to the db
// todo(kcampbell):
// 0. figure out how function auth works (outcome: set up postman query for required auth for functions)
// 1. follow walkthrough to connect to DB and create migration for initial tables/models
// 2. wire up get/post calls

namespace Icarus
{
    public static class ScoreTrigger
    {
        [FunctionName("ScoreTrigger")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            /* using(var db = new ScoreContext())
            {
                db.Scores.Add(new Score
                {
                    LatLng = "47.52325318073273 || -122.27435621176627",
                    DisplayName = "kfcampbell",
                    BaselineAltitude = 12.0,
                    PeakAltitude = 14.0,
                    BaselineVerticalAccuracy = 10.0,
                    PeakVerticalAccuracy = 12.0,
                    DateTime = "2019-02-17 11:40:32",
                    PhoneModel = "iPhone 6",
                    ThrowDuration = 0.0,
                    TimeStamp = DateTime.UtcNow
                });
                var count = await db.SaveChangesAsync();
                log.LogInformation($"{count} records written to DB");
            }*/

            return name != null
                ? (ActionResult)new OkObjectResult($"Hello, {name}")
                : new BadRequestObjectResult("Please pass a name on the query string or in the request body");
        }
    }
}
