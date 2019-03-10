using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using PlayFab;
using PlayFab.ClientModels;

namespace Icarus
{
    // UNTESTED!
    public static class LoginTrigger
    {
        [FunctionName("LoginTrigger")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("login trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            try
            {
                LoginWithIOSDeviceIDRequest requestFromDevice = JsonConvert.DeserializeObject<LoginWithIOSDeviceIDRequest>(requestBody);
                PlayFabSettings.TitleId = "6D64";
                requestFromDevice.CreateAccount = true;
                requestFromDevice.InfoRequestParameters = new GetPlayerCombinedInfoRequestParams
                {
                    GetUserData = true
                };

                var loginTask = await PlayFabClientAPI.LoginWithIOSDeviceIDAsync(requestFromDevice);
                Console.WriteLine(JsonConvert.SerializeObject(loginTask));


                return (ActionResult)new OkObjectResult("Login succeeded");
            }
            catch (Exception ex)
            {
                log.LogError($"Failure to log in: {ex}");
                return new BadRequestObjectResult($"Error logging in: {ex}");
            }
        }
    }
}
