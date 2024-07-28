using RestaurantManagement.Models;
using RestaurantManagement.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RestaurantManagement.Services
{
    public class MenuService
    {
        private readonly IMenuItemRepository _menuItemRepository;

        public MenuService(IMenuItemRepository menuItemRepository)
        {
            _menuItemRepository = menuItemRepository;
        }
        public void DisplayMenu()
        {
            var menuItems= _menuItemRepository.GetAll();
            foreach (var item in menuItems)
            {
                System.Console.WriteLine($"ID: {item.Id}, Name: {item.Name}, Price: {item.Price:C}");
            }
        }
        public void AddMenuItem(string name,decimal price)
        {
            var newMenuItem=new MenuItem { Name = name, Price = price };
            _menuItemRepository.Add(newMenuItem);
        }
        public void UpdaterMenuItem(int id,string name,decimal price)
        {
            var menuItem=_menuItemRepository.GetById(id);
            if (menuItem!=null)
            {
                menuItem.Name = name;
                menuItem.Price = price;
                _menuItemRepository.Update(menuItem);
            }
        }
        public void DeleteMenuItem(int id)
        {
            _menuItemRepository.Delete(id);
        }
    }
}
