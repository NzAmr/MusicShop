using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class addStateToStudio : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "StudioReservation",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Status",
                table: "StudioReservation");
        }
    }
}
