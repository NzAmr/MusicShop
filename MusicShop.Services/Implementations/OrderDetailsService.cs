﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Linq;
using System.Reflection.Metadata.Ecma335;

namespace MusicShop.Services.Implementations
{
    public class OrderDetailsService : BaseCRUDService<Model.OrderDetail, Database.OrderDetail, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest>, IOrderDetailService
    {
        public OrderDetailsService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override void BeforeInsert(OrderInsertRequest insert, OrderDetail entity)
        {
            entity.OrderDate = DateTime.Now;
            entity.ShippingStatus = "Pending";
            entity.OrderNumber = GenerateUniqueOrderNumber();
        }

        private string GenerateUniqueOrderNumber()
        {
            string orderNumber;
            bool isUnique;

            do
            {
                orderNumber = "ORD" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(1000, 9999).ToString();
                isUnique = !Context.OrderDetails.Any(o => o.OrderNumber == orderNumber);
            }
            while (!isUnique);

            return orderNumber;
        }
        public override IQueryable<OrderDetail> AddFilter(IQueryable<OrderDetail> query, OrderSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if(search.CustomerId != null)
            {
                filteredQuery = filteredQuery.Where(x=>x.ShippingInfo.CustomerId== search.CustomerId);
            }
            return filteredQuery;
        }

        public override IQueryable<OrderDetail> AddInclude(IQueryable<OrderDetail> query, OrderSearchObject? search = null)
        {
            query = query.Include(x => x.Product);
            query = query.Include(x => x.ShippingInfo);
            query = query.Include(x => x.Product.Brand);
            query = query.Include(x => x.ShippingInfo.Customer);
            return query;
        }
        public override Model.OrderDetail Update(int id, OrderUpdateRequest update)
        {
            return base.Update(id, update);
        }
    }
}