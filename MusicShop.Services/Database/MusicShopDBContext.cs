using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace MusicShop.Services.Database
{
    public partial class MusicShopDBContext : DbContext
    {
        public MusicShopDBContext()
        {
        }

        public MusicShopDBContext(DbContextOptions<MusicShopDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Amplifier> Amplifiers { get; set; } = null!;
        public virtual DbSet<Bass> Basses { get; set; } = null!;
        public virtual DbSet<Brand> Brands { get; set; } = null!;
        public virtual DbSet<Customer> Customers { get; set; } = null!;
        public virtual DbSet<Employee> Employees { get; set; } = null!;
        public virtual DbSet<Gear> Gears { get; set; } = null!;
        public virtual DbSet<GearCategory> GearCategories { get; set; } = null!;
        public virtual DbSet<Guitar> Guitars { get; set; } = null!;
        public virtual DbSet<GuitarType> GuitarTypes { get; set; } = null!;
        public virtual DbSet<Order> Orders { get; set; } = null!;
        public virtual DbSet<Product> Products { get; set; } = null!;
        public virtual DbSet<ProductImage> ProductImages { get; set; } = null!;
        public virtual DbSet<ShippingInfo> ShippingInfos { get; set; } = null!;
        public virtual DbSet<StudioReservation> StudioReservations { get; set; } = null!;
        public virtual DbSet<Synthesizer> Synthesizers { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Data Source=localhost, 1434;Initial Catalog=MusicShopDB; user=sa; Password=QWEasd123!");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {


            modelBuilder.Entity<Guitar>().ToTable("Guitar");
            modelBuilder.Entity<Bass>().ToTable("Bass");
            modelBuilder.Entity<Amplifier>().ToTable("Amplifier");
            modelBuilder.Entity<Synthesizer>().ToTable("Synthesizer");
            modelBuilder.Entity<Gear>().ToTable("Gear");

            modelBuilder.Entity<Brand>(entity =>
            {
                entity.ToTable("Brand");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<Customer>(entity =>
            {
                entity.ToTable("Customer");

                entity.Property(e => e.CreatedAt).HasColumnType("datetime");
                entity.Property(e => e.Email).HasMaxLength(100);
                entity.Property(e => e.FirstName).HasMaxLength(50);
                entity.Property(e => e.LastName).HasMaxLength(50);
                entity.Property(e => e.PasswordHash).HasMaxLength(50);
                entity.Property(e => e.PasswordSalt).HasMaxLength(50);
                entity.Property(e => e.PhoneNumber).HasMaxLength(20);
                entity.Property(e => e.UpdatedAt).HasColumnType("datetime");
                entity.Property(e => e.Username).HasMaxLength(50);
            });


            modelBuilder.Entity<Employee>(entity =>
            {
                entity.ToTable("Employee");

                entity.Property(e => e.CreatedAt).HasColumnType("datetime");

                entity.Property(e => e.DateOfBirth).HasColumnType("date");

                entity.Property(e => e.DateOfEmployment).HasColumnType("date");

                entity.Property(e => e.Email).HasMaxLength(100);

                entity.Property(e => e.FirstName).HasMaxLength(50);

                entity.Property(e => e.LastName).HasMaxLength(50);

                entity.Property(e => e.PasswordHash).HasMaxLength(50);

                entity.Property(e => e.PasswordSalt).HasMaxLength(50);

                entity.Property(e => e.PhoneNumber).HasMaxLength(20);

                entity.Property(e => e.UpdatedAt).HasColumnType("datetime");

                entity.Property(e => e.Username).HasMaxLength(50);
            });

           

            modelBuilder.Entity<GearCategory>(entity =>
            {
                entity.ToTable("GearCategory");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            

            modelBuilder.Entity<GuitarType>(entity =>
            {
                entity.ToTable("GuitarType");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<Order>(entity =>
            {

                modelBuilder.Entity<Order>().ToTable("Order");

                entity.Property(e => e.OrderDate).HasColumnType("date");

                entity.Property(e => e.OrderNumber).HasMaxLength(50);


                entity.Property(e => e.ShippingStatus).HasMaxLength(50);

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.OrderDetails)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK_OrderDetails_Product");
            });

            

            modelBuilder.Entity<ProductImage>(entity =>
            {
                entity.ToTable("ProductImage");
            });

            modelBuilder.Entity<ShippingInfo>(entity =>
            {
                entity.ToTable("ShippingInfo");

                entity.Property(e => e.Country).HasMaxLength(50);
                entity.Property(e => e.StateOrProvince).HasMaxLength(50);
                entity.Property(e => e.City).HasMaxLength(50);
                entity.Property(e => e.StreetAddress).HasMaxLength(50);
                entity.Property(e => e.ZipCode).HasMaxLength(12);

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.ShippingInfos) 
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ShippingInfo_Customer");
            });


            modelBuilder.Entity<StudioReservation>(entity =>
            {
                entity.ToTable("StudioReservation");

                entity.Property(e => e.TimeFrom).HasColumnType("datetime");

                entity.Property(e => e.TimeTo).HasColumnType("datetime");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.StudioReservations)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("FK_StudioReservation_Customer");
            });

            

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
