using Microsoft.EntityFrameworkCore;


namespace megaAPI.Data
{
    public class megaContext : DbContext
    {
        public megaContext(DbContextOptions<megaContext> options) : base(options) {}

    }
}