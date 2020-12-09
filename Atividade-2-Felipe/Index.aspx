<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNova.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Atividade_2_Felipe.Index"%>

<asp:Content ID="Content1" ContentPlaceHolderID="cphEstilosCabecalho" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphScriptsCabecalho" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphChamadasScripts" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphScripts" runat="server">
    <script>

        //Variaveis

        var grdGeral = null;
        var grdPageAtualizar = false;
        //var colSortable = "";
        var usuarioLogado = "perfil";
        var txtCliente = null;
        var divNotificacao = null;

        pageGrid = pegaValorInteiro(gerenciarDadosNavegacao(storageEnum.GetSessionStorage, "pageGrid", ""), 1);
        //colSortable = gerenciarDadosNavegacao(storageEnum.GetLocalStorage, usuarioLogado + "colSortable", "");
        //colTypeSortable = gerenciarDadosNavegacao(storageEnum.GetLocalStorage, usuarioLogado + "colTypeSortable", "");
        controleMsg = gerenciarDadosNavegacao(storageEnum.GetSessionStorage, "controleMsg", "") === null ? "N" : "S";

        //Métodos

        $(document).ready(function () {

            btnAdicionar = $("#btnAdicionar").kendoButton({
                click: btnAdicionar_onClick
            }).data("kendoButton");

            // GridGeral
            dataSource = new kendo.data.DataSource({
                serverPaging: true,
                serverFiltering: true,
                serverSorting: true,
                page: pageGrid,
                batch: true,
                pageSize: 10,
                schema: {
                    data: "Data",
                    model: {
                        id: "IdClient",
                        fields: {
                            IdClient: { type: "int" },
                            NameClient: { type: "string" },
                            Updated: { type: "string" }
                        }
                    }
                },
                logic: "and",
                transport: {
                    read: {
                        url: "https://avaliacao1.azurewebsites.net/api/v1/client/clients",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        type: "GET",
                        cache: false
                    },
                    parameterMap: function (data, operation) {
                        kendo.ui.progress($("#grdGeral"), false);
                        return JSON.stringify(data);
                    }
                },
            });

            function colunasGrid() {

                var colunasGrid = [];


                colunasGrid.push({ name: "btnAlterar", template: $("#btn-templateAlterar").html(), width: 33, lockable: false, locked: true, sortable: false, filterable: false });

                colunasGrid.push({ name: "btnExcluir", template: $("#btn-templateExcluir").html(), width: 33, lockable: false, locked: true, sortable: false, filterable: false });

                //colunasGrid.push({ name: "Id", field: "IdClient", title: "   Código Cliente", width: 200, filterable: true, sortable: true, hidden: false, locked: false, headerAttributes: { style: "text-align:left" } });
                colunasGrid.push({ name: "Cliente", field: "NameClient", title: "   Cliente", width: 200, filterable: true, sortable: true, hidden: false, locked: false, headerAttributes: { style: "text-align:left" } });
                colunasGrid.push({ name: "Update", field: "Updated", title: "   Ultima Atualização", width: 200, filterable: true, sortable: true, hidden: false, locked: false, headerAttributes: { style: "text-align:left" } });

                return colunasGrid;
            }

            grdGeral = $("#grdGeral").kendoGrid({
                dataSource: dataSource,
                resizable: true,
                sortable: true,
                filterable: true,
                reorderable: true,
                messages: messagesGrid,
                columns: colunasGrid(),
                pageable: true,
                pageable: {
                    refresh: true,
                    buttonCount: 10,
                    pageSizes: [10, 20, 30, 40, 50],
                    messages: pageableMessagesGrid
                },
                filterable: {
                    messages: filterableMessagesGrid,
                    extra: false,
                    operators: {
                        string: filterableOperatorsStringGridDefault,
                        number: filterableOperatorsNumberGrid,
                        date: filterableOperatorsDateGrid
                    }
                },
                columnMenu: {
                    sortable: false,
                    messages: columnMenuMessagesGrid
                }
            }).data("kendoGrid");

            grdGeral.thead.kendoTooltip({
                filter: "th",
                position: "top",
                showAfter: 1000,
                animation: {
                    open: {
                        effects: "fade:in",
                        duration: 200
                    }, close: {
                        effects: "fade:out",
                        duration: 500
                    }
                },
                content: function (e) {

                    var target = e.target;

                    if (target[0].dataset.field === "btnAlterar")
                        return "Alterar cadastro";
                    else if (target[0].dataset.field === "btnExcluir")
                        return "Excluir cadastro";
                    else if (target[0].dataset.field === "Cliente")
                        return "Cliente";
                }
            });
        });

        //Eventos

        function alterar(e) {

            var mygrdGeral = $("#grdGeral").data("kendoGrid");
            var tr = $(e).closest("tr");
            var dataItem = mygrdGeral.dataItem(tr);
            var IdClient = dataItem.IdClient;
            var NameClient = dataItem.NameClient;

            location.href = "Cadastro.aspx?IdClient=" + IdClient + "&NameClient=" + NameClient;
        }

        function excluir(e) {

            var mygrdGeral = $("#grdGeral").data("kendoGrid");
            var tr = $(e).closest("tr");
            var dataItem = mygrdGeral.dataItem(tr);
            var IdClient = dataItem.IdClient;

                    $.ajax({
                        type: "DELETE",
                        url: "https://avaliacao1.azurewebsites.net/api/v1/client/clients/" + dataItem.IdClient,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data:
                            function (data) {
                                JSON.stringify(
                                    data
                                )
                            },
                        success: function (response) {
                                exibirAlerta("erro", $("#msgSucesso"), "Dados excluidos com sucesso!.");
                                grdGeral.dataSource.remove(dataItem);
                                grdGeral.dataSource.read();
                        },
                        error: function () {
                            exibirAlerta("erro", $("#msgErro"), "Ocorreu um erro ao excluir os dados.");
                        }
                    });
        }

        function btnAdicionar_onClick() {
            location.href = "Cadastro.aspx?IdClient=" + 0;
        }

    </script>

    <script id="btn-templateAlterar" type="text/x-kendo-template">
        <div style='text-align:center;'><a id='btnAlt#=String(IdClient)+"_" + String(NameClient)#' title='Excluir o Cliente: #=NameClient#' name='glyphicon glyphicon-edit' onclick="alterar(this)" class='k-grid-Update' href='\\#' style='color:\\#D65F16; font-size: 12pt;'><i class='glyphicon glyphicon-edit'></i></a></div>
    </script>


    <script id="btn-templateExcluir" type="text/x-kendo-template">
        <div style='text-align:center;'><a id='btnExc#=String(IdClient)+"_" + String(NameClient)#' title='Excluir o Cliente: #=NameClient#' name='fa fa-minus-square' onclick="excluir(this)" class='k-grid-Delete' href='\\#' style='color:\\#0aa89e; font-size: 12pt;'  ><i class='fa fa-minus-square'></i></a></div>
    </script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudo" runat="server">
    <section>
        <div class="section-header">
            <ol class="breadcrumb">
            </ol>
        </div>
        <div class="section-body bip-conteudo-elastico">
            <div class="row">
                <div class="col-xs-12">
                    <div class="card">
                        <div class="card-head">
                            <header style="padding-left: 12px">
                                <span class="glyphicon glyphicon-list" style="vertical-align: text-top;"></span>
                                Lista de Clientes
                            </header>
                            <div class="tools" style="padding-right: 8px">
                                <ul id="linha1">
                                    <li id="linha01">
                                        <div class="btn-group pesquisa-cadastros">
                                            <input style="width: 170px; height: 30px; margin-left: 0px;" tabindex="3" id="txtFindGrid" type="text" placeholder="Pesquisar" name="_txtFindGrid" class="k-textbox" onkeydown="return onKeyPress(event,this.tabIndex)" />
                                        </div>
                                        <button style="margin-left: -30px;" class="k-button k-secondary btnFiltroCadastros" tabindex="4" type="button" id="btnFiltrar" name="load/fa fa-search"><i class="fa fa-search"></i></button>
                                        <button style="margin-left: 5px" class="k-button k-secondary btnFiltroCadastros" tabindex="5" type="button" id="btnLimpar" title="Limpar" name="fa fa-minus-square"><i class="fa fa-eraser"></i></button>
                                        <div class="btn-group">
                                            <button class="k-button k-primary" tabindex="7" type="button" id="btnAdicionar" name="load/fa fa-plus-square"><i class="fa fa-plus-square"></i>&nbsp;&nbsp;NOVO</button>
                                        </div>
                                        <div class="btn-group">
                                            <a class="btn btn-icon-toggle dropdown-toggle" href="#" data-toggle="dropdown" title="Mais..."><i class="md md-more-vert"></i></a>
                                            <ul class="dropdown-menu animation-dock pull-right menu-card-styling" role="menu" style="text-align: left;">
                                                <li><a verificarupload data-style="style-default-dark"><i class="fa fa-upload"></i>&nbsp;Upload de dados</a></li>
                                                <li><a verificardownload data-style="style-default-dark"><i class="fa fa-download"></i>&nbsp;Download de dados</a></li>
                                            </ul>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="card-body">
                            <div id="grdGeral" class="bip-grid-elastico"></div>
                            <div id="divMsgAlertas" style="width: 800px; padding-top: 20px">
                                <div id="msgAlerta" class="alert alert-warning alerta-geral"></div>
                                <div id="msgSucesso" class="alert alert-success sucesso-geral"></div>
                                <div id="msgErro" class="alert alert-danger erro-geral"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="fundoGeral"><i class="DivPreloader glyphicon glyphicon-filter"></i></div>
    </section>
</asp:Content>
