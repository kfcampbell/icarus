using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace server.Migrations
{
    public partial class DropDatetime : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DateTime",
                table: "Scores");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DateTime",
                table: "Scores",
                nullable: true);
        }
    }
}
