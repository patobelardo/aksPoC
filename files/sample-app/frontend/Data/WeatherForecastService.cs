using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace frontend.Data
{
    public class WeatherForecastService
    {
        private readonly IHttpClientFactory _clientFactory;
        public WeatherForecastService(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        public async Task<WeatherForecast[]> GetForecastAsync(DateTime startDate)
        {
            WeatherForecast[] forecastInfo = new WeatherForecast[0];
            var webapiURL = Environment.GetEnvironmentVariable("WebAPI");
            if (webapiURL.IndexOf("http") == -1)
                webapiURL = $"http://{webapiURL}";
            if (webapiURL.Substring(webapiURL.Length - 1, 1) == "/")
                webapiURL = webapiURL.Substring(0, webapiURL.Length - 1);
                
             var request = new HttpRequestMessage(HttpMethod.Get, $"{webapiURL}/weatherforecast");

            var client = _clientFactory.CreateClient();

            try
            {
                var response = await client.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    string str = await response.Content.ReadAsStringAsync();
                    forecastInfo = Newtonsoft.Json.JsonConvert.DeserializeObject<WeatherForecast[]>(str);
                }

                return forecastInfo;
                //var rng = new Random();
                //return Task.FromResult(Enumerable.Range(1, 5).Select(index => new WeatherForecast
                //{
                //    Date = startDate.AddDays(index),
                //    TemperatureC = rng.Next(-20, 55),
                //    Summary = Summaries[rng.Next(Summaries.Length)]
                //}).ToArray());
            }
            catch(Exception ex)
            {
                throw;
            }
        }
    }
}
