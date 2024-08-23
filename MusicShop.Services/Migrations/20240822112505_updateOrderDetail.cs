using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class updateOrderDetail : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetails_Customer_CustomerId",
                table: "OrderDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetails_Employee_EmployeeId",
                table: "OrderDetails");

            migrationBuilder.DropIndex(
                name: "IX_OrderDetails_CustomerId",
                table: "OrderDetails");

            migrationBuilder.DropColumn(
                name: "CustomerId",
                table: "OrderDetails");

            migrationBuilder.RenameColumn(
                name: "EmployeeId",
                table: "OrderDetails",
                newName: "ShippingInfoId");

            migrationBuilder.RenameIndex(
                name: "IX_OrderDetails_EmployeeId",
                table: "OrderDetails",
                newName: "IX_OrderDetails_ShippingInfoId");

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetails_ShippingInfo_ShippingInfoId",
                table: "OrderDetails",
                column: "ShippingInfoId",
                principalTable: "ShippingInfo",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetails_ShippingInfo_ShippingInfoId",
                table: "OrderDetails");

            migrationBuilder.RenameColumn(
                name: "ShippingInfoId",
                table: "OrderDetails",
                newName: "EmployeeId");

            migrationBuilder.RenameIndex(
                name: "IX_OrderDetails_ShippingInfoId",
                table: "OrderDetails",
                newName: "IX_OrderDetails_EmployeeId");

            migrationBuilder.AddColumn<int>(
                name: "CustomerId",
                table: "OrderDetails",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_OrderDetails_CustomerId",
                table: "OrderDetails",
                column: "CustomerId");

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetails_Customer_CustomerId",
                table: "OrderDetails",
                column: "CustomerId",
                principalTable: "Customer",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetails_Employee_EmployeeId",
                table: "OrderDetails",
                column: "EmployeeId",
                principalTable: "Employee",
                principalColumn: "Id");
        }
    }
}
