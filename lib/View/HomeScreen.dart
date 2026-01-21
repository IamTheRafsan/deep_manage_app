import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:deep_manage_app/Component/GlobalScaffold/GlobalScaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy Data
  final List<StatCardData> stats = [
    StatCardData(
      title: 'Total Sales',
      value: '₹ 1,85,420',
      change: '+12.5%',
      icon: Icons.attach_money,
      color: Colors.green,
      isPositive: true,
    ),
    StatCardData(
      title: 'Total Expenses',
      value: '₹ 64,320',
      change: '-8.2%',
      icon: Icons.money_off,
      color: Colors.red,
      isPositive: false,
    ),
    StatCardData(
      title: 'Net Profit',
      value: '₹ 1,21,100',
      change: '+15.3%',
      icon: Icons.trending_up,
      color: Colors.blue,
      isPositive: true,
    ),
    StatCardData(
      title: 'Products Sold',
      value: '1,248',
      change: '+23.1%',
      icon: Icons.shopping_cart,
      color: Colors.orange,
      isPositive: true,
    ),
    StatCardData(
      title: 'Low Stock Items',
      value: '24',
      change: 'Need Attention',
      icon: Icons.warning,
      color: Colors.amber,
      isPositive: false,
    ),
    StatCardData(
      title: 'Active Customers',
      value: '342',
      change: '+8.7%',
      icon: Icons.people,
      color: Colors.purple,
      isPositive: true,
    ),
  ];

  final List<MonthlySales> monthlySales = [
    MonthlySales(month: 'Jan', sales: 125000, expenses: 45000),
    MonthlySales(month: 'Feb', sales: 145000, expenses: 52000),
    MonthlySales(month: 'Mar', sales: 165000, expenses: 48000),
    MonthlySales(month: 'Apr', sales: 185000, expenses: 55000),
    MonthlySales(month: 'May', sales: 175000, expenses: 50000),
    MonthlySales(month: 'Jun', sales: 195000, expenses: 60000),
  ];

  final List<TopProduct> topProducts = [
    TopProduct(name: 'Smartphone X', sales: 124, revenue: 892800),
    TopProduct(name: 'Laptop Pro', sales: 89, revenue: 712000),
    TopProduct(name: 'Wireless Earbuds', sales: 156, revenue: 312000),
    TopProduct(name: 'Smart Watch', sales: 98, revenue: 294000),
    TopProduct(name: 'Tablet Mini', sales: 67, revenue: 234500),
  ];

  final List<RecentTransaction> recentTransactions = [
    RecentTransaction(
      customer: 'John Doe',
      type: 'Sale',
      amount: 24999,
      time: '2 hours ago',
      status: 'Completed',
    ),
    RecentTransaction(
      customer: 'Tech Solutions Ltd',
      type: 'Purchase',
      amount: 125000,
      time: '5 hours ago',
      status: 'Pending',
    ),
    RecentTransaction(
      customer: 'Sarah Smith',
      type: 'Sale',
      amount: 45999,
      time: 'Yesterday',
      status: 'Completed',
    ),
    RecentTransaction(
      customer: 'Office Supplies',
      type: 'Expense',
      amount: 12500,
      time: '2 days ago',
      status: 'Completed',
    ),
    RecentTransaction(
      customer: 'Mike Johnson',
      type: 'Sale',
      amount: 32999,
      time: '3 days ago',
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Inventory Dashboard",
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _buildWelcomeHeader(),

            // Stats Grid
            _buildStatsGrid(),

            // Charts Section
            _buildChartsSection(),

            // Top Products
            _buildTopProducts(),

            // Recent Transactions
            _buildRecentTransactions(),

            // Quick Actions
            _buildQuickActions(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Here\'s what\'s happening with your store today',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.access_time, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return _buildStatCard(stats[index]);
        },
      ),
    );
  }

  Widget _buildStatCard(StatCardData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, color: data.color, size: 24),
                ),
                Chip(
                  label: Text(
                    data.change,
                    style: TextStyle(
                      color: data.isPositive ? Colors.green : Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: data.isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sales & Expenses Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Last 6 Months',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(monthlySales[value.toInt()].month);
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('₹${(value / 1000).toInt()}K');
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: monthlySales
                            .asMap()
                            .entries
                            .map((e) => FlSpot(
                          e.key.toDouble(),
                          e.value.sales / 1000,
                        ))
                            .toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                      LineChartBarData(
                        spots: monthlySales
                            .asMap()
                            .entries
                            .map((e) => FlSpot(
                          e.key.toDouble(),
                          e.value.expenses / 1000,
                        ))
                            .toList(),
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChartLegend('Sales', Colors.green),
                  const SizedBox(width: 20),
                  _buildChartLegend('Expenses', Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Selling Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...topProducts.map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProductItem(product),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(TopProduct product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.sales} units sold',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${product.revenue.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                'Revenue',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...recentTransactions.map((transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTransactionItem(transaction),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(RecentTransaction transaction) {
    Color typeColor = transaction.type == 'Sale'
        ? Colors.green
        : transaction.type == 'Purchase'
        ? Colors.blue
        : Colors.red;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          transaction.type == 'Sale'
              ? Icons.shopping_cart
              : transaction.type == 'Purchase'
              ? Icons.shopping_bag
              : Icons.money_off,
          color: typeColor,
        ),
      ),
      title: Text(
        transaction.customer,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(transaction.time),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '₹ ${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.type == 'Expense' ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: transaction.status == 'Completed'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              transaction.status,
              style: TextStyle(
                fontSize: 10,
                color: transaction.status == 'Completed'
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      QuickAction(
        icon: Icons.add,
        label: 'New Sale',
        color: Colors.green,
      ),
      QuickAction(
        icon: Icons.inventory,
        label: 'Add Stock',
        color: Colors.blue,
      ),
      QuickAction(
        icon: Icons.people,
        label: 'Add Customer',
        color: Colors.purple,
      ),
      QuickAction(
        icon: Icons.assessment,
        label: 'Generate Report',
        color: Colors.orange,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: actions
                    .map((action) => _buildQuickActionButton(action))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(QuickAction action) {
    return SizedBox(
      width: 120,
      child: ElevatedButton.icon(
        onPressed: () {
          // Handle action
        },
        icon: Icon(action.icon, size: 20),
        label: Text(
          action.label,
          style: const TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: action.color.withOpacity(0.1),
          foregroundColor: action.color,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// Data Models
class StatCardData {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final bool isPositive;

  StatCardData({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    required this.isPositive,
  });
}

class MonthlySales {
  final String month;
  final double sales;
  final double expenses;

  MonthlySales({
    required this.month,
    required this.sales,
    required this.expenses,
  });
}

class TopProduct {
  final String name;
  final int sales;
  final double revenue;

  TopProduct({
    required this.name,
    required this.sales,
    required this.revenue,
  });
}

class RecentTransaction {
  final String customer;
  final String type;
  final double amount;
  final String time;
  final String status;

  RecentTransaction({
    required this.customer,
    required this.type,
    required this.amount,
    required this.time,
    required this.status,
  });
}

class QuickAction {
  final IconData icon;
  final String label;
  final Color color;

  QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });
}