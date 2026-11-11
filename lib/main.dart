
import 'package:flutter/material.dart';

void main() {
  runApp(const BurgerHouse());
}

class BurgerHouse extends StatelessWidget {
  const BurgerHouse({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Burger House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const LojaPage(),
    );
  }
}

class LojaPage extends StatefulWidget {
  const LojaPage({super.key});

  @override
  State<LojaPage> createState() => _LojaPageState();
}

class _LojaPageState extends State<LojaPage> {
  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Hambúrguer Clássico',
      'descricao': 'Pão, carne, queijo e molho especial',
      'preco': 18.00,
      'emoji': '🍔',
    },
    {
      'nome': 'X-Bacon',
      'descricao': 'Carne, queijo, bacon e alface',
      'preco': 25.00,
      'emoji': '🥓',
    },
    {
      'nome': 'X-Tudo',
      'descricao': 'Carne, queijo, ovo, bacon e salada',
      'preco': 30.00,
      'emoji': '🍔',
    },
    {
      'nome': 'Combo Especial',
      'descricao': 'Hambúrguer, batata frita e refrigerante',
      'preco': 35.00,
      'emoji': '🍟',
    },
  ];

  final Map<int, int> carrinho = {};

  double get total {
    double valor = 0;

    carrinho.forEach((indice, quantidade) {
      valor += produtos[indice]['preco'] * quantidade;
    });

    return valor;
  }

  int get quantidadeTotal =>
      carrinho.values.fold(0, (soma, qtd) => soma + qtd);

  void adicionar(int indice) {
    setState(() {
      carrinho[indice] = (carrinho[indice] ?? 0) + 1;
    });
  }

  void remover(int indice) {
    setState(() {
      if ((carrinho[indice] ?? 0) > 1) {
        carrinho[indice] = carrinho[indice]! - 1;
      } else {
        carrinho.remove(indice);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
        title: const Text(
          '🍔 BURGER HOUSE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text('🛒 $quantidadeTotal'),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'O MELHOR HAMBÚRGUER DA CIDADE!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Escolha seu favorito e monte seu pedido.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              ...List.generate(produtos.length, (indice) {
                final produto = produtos[indice];
                final quantidade = carrinho[indice] ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          produto['emoji'],
                          style: const TextStyle(fontSize: 42),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                produto['nome'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(produto['descricao']),
                              const SizedBox(height: 8),
                              Text(
                                'R\$ ${(produto['preco'] as double).toStringAsFixed(2).replaceAll('.', ',')}',
                                style: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (quantidade > 0)
                          IconButton(
                            onPressed: () => remover(indice),
                            icon: const Icon(Icons.remove_circle),
                          ),
                        if (quantidade > 0)
                          Text('$quantidade'),
                        IconButton(
                          onPressed: () => adicionar(indice),
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),
              Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'RESUMO DO PEDIDO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Itens: $quantidadeTotal'),
                      const SizedBox(height: 8),
                      Text(
                        'Total: R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (quantidadeTotal == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Adicione um lanche ao carrinho!',
                                  ),
                                ),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Pedido confirmado! 🎉'),
                                content: Text(
                                  'Seu pedido tem $quantidadeTotal item(ns).\n'
                                      'Total: R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}\n\n'
                                      'Esta é uma demonstração. Nenhum pagamento foi realizado.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text('FINALIZAR PEDIDO'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
