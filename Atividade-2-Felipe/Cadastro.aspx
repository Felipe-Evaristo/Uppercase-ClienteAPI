<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNova.Master" AutoEventWireup="true" CodeBehind="Cadastro.aspx.cs" Inherits="Atividade_2_Felipe.Cadastro" %>

<asp:Content ID="Content4" ContentPlaceHolderID="cphChamadasScripts" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphEstilosCabecalho" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphScriptsCabecalho" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        $(document).ready(function () {

            //Variáveis

            var btnSalvar = null;
            var txtCliente = "";
            var c = null;
            var IdClient = RequisicaoLerParametro("IdClient");
            var NameClient = RequisicaoLerParametro("NameClient");

            btnVoltar = $("#btnVoltar").kendoButton({
                click: btnVoltar_onClick
            }).data("kendoButton");

            btnSalvar = $("#btnSalvar").kendoButton({
                click: btnSalvar_onClick
            }).data("kendoButton");

            txtCliente = document.getElementById("txtCliente");

            function carregaCampos() {
                $.ajax({
                    type: "GET",
                    url: "https://avaliacao1.azurewebsites.net/api/v1/client/clients/" + IdClient,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    cache: false,
                    data: JSON.stringify({
                        'IdClient': IdClient,
                        'NameClient': NameClient
                    }),
                    success: function (msg) {
                        jsonCliente = msg;
                        if (jsonCliente.Data.length !== 0) {
                            txtCliente.value = jsonCliente.Data.NameClient;
                        }
                    },
                    error: function (data) {
                        alert("Erro ao carregar dados");
                    }
                });
            }

            //Método para carregar o campo

            if (IdClient != 0) {
                carregaCampos();
            }

            //Método para Alterar/Editar

            function btnSalvar_onClick() {

                var url = "https://avaliacao1.azurewebsites.net/api/v1/client/clients";


                if (IdClient == 0) {
                    $.ajax({
                        type: "POST",
                        url: url,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({
                            'IdClient': GuildId(),
                            'NameClient': txtCliente.value
                        }),
                        success: function (response) {
                            location.href = "Index";
                        },
                        error: function () {
                            exibirAlerta("erro", $("#msgErro"), "Ocorreu um erro ao salvar os dados.", "btnSalvar");
                            ocultarAnimacaoCarregandoBotao("#btnSalvar");
                        }
                    });
                }

                else {
                    $.ajax({
                        type: "PUT",
                        url: url,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({
                            'IdClient': IdClient,
                            'NameClient': txtCliente.value
                        }),
                        success: function (response) {
                            location.href = "Index";
                        },
                        error: function () {
                            exibirAlerta("erro", $("#msgErro"), "Ocorreu um erro ao alterar os dados.", "btnSalvar");
                            ocultarAnimacaoCarregandoBotao("#btnSalvar");
                        }
                    });
                }

            }

        });

         //Métodos

         //Eventos

        function btnVoltar_onClick() {
            location.href = "Index";
        }

        function GuildId() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudo" runat="server">
    <section>
        <div class="section-header">
            <ol class="breadcrumb">
                <li><span class="md md-view-list brc-icone-link"></span><a href="perfilLista.aspx?pagChild=true">Cadastrar Cliente</a></li>
            </ol>
        </div>
        <div class="section-body bip-conteudo-elastico">
            <div class="card">
                <div class="card-head">
                    <header style="padding-left: 10px">
                        <span class="glyphicon glyphicon-edit" style="vertical-align: text-top;"></span>
                        Cadastro de Perfil de Acesso
                    </header>
                    <div class="tools">
                        <div id="guiaPerfil">
                            <div class="btn-group">
                                <button class="k-button k-primary" tabindex="3" type="button" id="btnVoltar" title="Voltar" name="load/fa fa-plus-square">&nbsp;VOLTAR</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="card">
            <div id="divTabCadastro" class="bip-grid-elastico" style="overflow-y: auto; overflow-x: hidden;">
                <ul class="nav nav-tabs" data-toggle="tabs" style="margin-left: 0px; font-size: 10pt; cursor: pointer">
                    <li class="active"><a data-toggle="tab" id="liClientes" tabindex="1">CLIENTES</a></li>
                </ul>

                <div id="frmCliente" style="padding-top: 20px;">
                    <div id="divCliente">
                        <ul class="lista-campos-form" style="padding-top: 20px">
                            <li>
                                <label for="txtCliente">Nome do cliente:</label>
                                <input id="txtCliente" tabindex="3" type="text" name="_txtCliente" class="k-textbox" style="width: 350px;" required validationmessage=" " />
                                <span title="Validação Formulário" class="k-invalid-msg" data-for="_txtCliente"></span>
                            </li>
                            <li>
                                <label for="btnSalvar"></label>
                                <button type="button" tabindex="8" class="k-button k-primary" id="btnSalvar" name="load/fa fa-check"><i class="fa fa-check"></i>&nbsp;&nbsp;SALVAR</button>
                                &nbsp;
                                    <button type="button" class="k-button k-button-cancel" tabindex="9" id="btnCancelar"><i class="fa fa-close"></i>&nbsp;&nbsp;CANCELAR</button>
                            </li>
                        </ul>

                    </div>

                    <div id="tlstGeral" style="font-size: 12px; display: none; margin-left: 10px; margin-top: 10px;"></div>

                    <div id="tlstGInterface" style="font-size: 12px; display: none; margin-left: 10px; margin-top: 10px;"></div>

                    <div id="divMsgAlertas" style="width: 800px; padding-top: 20px">
                        <div id="msgAlerta" class="alert alert-warning alerta-geral"></div>
                        <div id="msgSucesso" class="alert alert-success sucesso-geral"></div>
                        <div id="msgErro" class="alert alert-danger erro-geral"></div>
                    </div>
                </div>
            </div>
        </div>
        <div id="fundoGeral"><i class="DivPreloader glyphicon glyphicon-filter"></i></div>
    </section>

</asp:Content>
