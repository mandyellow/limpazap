import 'package:flutter/material.dart';
import '../model/ArquivoDeletavelModel.dart';
import '../controller/SnackbarController.dart';
import 'dart:async';

class ArquivoWidget extends StatelessWidget {
  final ArquivoDeletavel arquivo;
  final StreamController<ArquivoDeletavel> chan;
  ArquivoWidget(this.arquivo, this.chan);

  Widget build(BuildContext ctx) {
    var d = arquivo.dataCriacao;
    var texto =
        "${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute < 10 ? '0' : ''}${d.minute}";
    var tamanho = "${(this.arquivo.tamanho / 1000000).round()} MB";
    var elemento = ListTile(
        title: Row(children: <Widget>[
          Icon(arquivo.isUltimo ? Icons.warning : Icons.history),
          Text(texto, style: TextStyle(fontSize: 36) // TextStyle
              ), // Text
        ]), // Row
        subtitle: Row(children: <Widget>[
          Icon(Icons.sd_card),
          Text(tamanho, style: TextStyle(fontSize: 28) // TextStyle
              ) // Text
        ]) // Row
        ); // ListTile
    return Center(
        child: Dismissible(
            key: Key(this.arquivo.arquivo.path),
            child: Center(child: elemento),
            background: Container(color: Colors.red, child: Icon(Icons.delete)),
            confirmDismiss: ((_) async {
              var sc = SnackbarController(
                  ctx,
                  SnackBar(
                      content: Text(
                          "Não é possível apagar este arquivo manualmente.\n" +
                              "Toque em limpar tudo para apagar todos os backups!")) // SnackBar
                  ); // SnackBarController
              if (this.arquivo.isUltimo) sc.show();
              return !this.arquivo.isUltimo;
            }),
            onDismissed: (_) {
              chan.add(this.arquivo);
              SnackbarController(
                      ctx,
                      SnackBar(
                          content:
                              Text("Apagado $texto liberando $tamanho!") // Text
                          ) // SnackBar
                      )
                  .show();
            }) // Dismissible
        );
  }
}
