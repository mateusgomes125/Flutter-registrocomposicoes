class Composicao{

  final String id;
  final String titulo;
  final String descricao;
  final String datahora;
  final String CID;
  final String userId;
  final String nomeArquivo;

  Composicao(
      this.id,
      this.titulo,
      this.descricao,
      this.datahora,
      this.CID,
      this.userId,
      this.nomeArquivo);

  @override
  String toString() {
    return "Composição($titulo, $datahora, $CID)";
  }

}