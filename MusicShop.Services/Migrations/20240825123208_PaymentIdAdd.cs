using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class PaymentIdAdd : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PaymentId",
                table: "OrderDetails",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PaymentId",
                table: "OrderDetails");
        }
    }
}
