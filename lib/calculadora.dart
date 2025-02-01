// Suggested code may be subject to a license. Learn more: ~LicenseLog:3578400727.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1914711365.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1582248946.
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _ce = 'CE';
  final String _limpar = 'Limpar';
  final String _media = 'Media';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == 'Limpar') {
        _expressao = '';
      } else if (valor == 'CE') {
        _expressao = '';
        _resultado = '';
      } else if (valor == 'Media') {
        _calcularMedia();
      } else if (valor == '=') {
        _calcularResultado();
      } else if (valor == 'apagar') {
        if (_expressao.isNotEmpty) {
          _expressao = _expressao.substring(0, _expressao.length - 1);
        }
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularMedia() {
    setState(() {
      List<String> numeros = _expressao.split('+');
      _resultado = _avaliarMedia(numeros).toString();
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro: dados invalidos';
      debugPrint('Erro: dados invalidos: $e');
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('×', '*').replaceAll('÷', '/');

    Parser parser = Parser();
    Expression exp = parser.parse(expressao);

    ContextModel contexto = ContextModel();
    double resultado = exp.evaluate(EvaluationType.REAL, contexto);

    return resultado;
  }

  double _avaliarMedia(List<String> numeros) {
    double soma = 0;
    int quantidade = 0;

    for (String numero in numeros) {
      double valor = double.tryParse(numero) ?? 0;
      soma += valor;
      quantidade++;
    }

    double media = quantidade > 0 ? soma / quantidade : 0;
    return media;
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 48),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 32),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('^'),
              _botao('!'),
              _botao('('),
              _botao(')'),
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('×'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('.'),
              _botao('0'),
              _botao('='),
              _botao('+'),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _botao(_ce),
              _botao(_limpar),
              _botao(_media),
              _botao(_limpar),
              IconButton(
                onPressed: () => _pressionarBotao('apagar'),
                icon: const Icon(Icons.backspace),
              )
            ],
          ),
        ),
      ],
    );
  }
}