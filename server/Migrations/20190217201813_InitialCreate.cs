using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace server.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Scores",
                columns: table => new
                {
                    ScoreId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    BaselineAltitude = table.Column<double>(type: "float", nullable: false),
                    DateTime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LatLng = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PeakAltitude = table.Column<double>(type: "float", nullable: false),
                    PhoneModel = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ThrowDuration = table.Column<double>(type: "float", nullable: false),
                    baselineVerticalAccuracy = table.Column<double>(type: "float", nullable: false),
                    peakVerticalAccuracy = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Scores", x => x.ScoreId);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Scores");
        }
    }
}
