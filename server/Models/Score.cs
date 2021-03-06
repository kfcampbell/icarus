using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

namespace Icarus
{
    public class ScoreContext : DbContext
    {
        public DbSet<Score> Scores { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(Environment.GetEnvironmentVariable("DB_CONNECTION_STRING"));
        }
    }

    public class HighScoreFromClient
    {
        public string PlayFabId { get; set; }

        // since playfab statistics can only store ints, we store meters multiplied by 10
        // e.g. 545 in statistics corresponds to 5.45 meters tossed
        public int MetersMultipliedByTen { get; set; }
    }

    public class Score
    {
        public int ScoreId { get; set; }
        public string LatLng { get; set; }
        public string DisplayName { get; set; }
        public double BaselineAltitude { get; set; }
        public double PeakAltitude { get; set; }
        public double BaselineVerticalAccuracy { get; set; }
        public double PeakVerticalAccuracy { get; set; }
        public DateTime TimeStamp { get; set; }
        public string PhoneModel { get; set; }
        public double ThrowDuration { get; set; }
    }
}