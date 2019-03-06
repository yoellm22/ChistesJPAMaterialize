<%-- 
    Document   : home
    Created on : 30-ene-2019, 12:12:48
    Author     : Yoel
--%>

<%@page import="java.math.BigDecimal"%>
<%@page import="entities.Puntos"%>
<%@page import="entities.Chiste"%>
<%@page import="java.util.List"%>
<%@page import="entities.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <!--Import Google Icon Font-->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="css/materialize.min.css" media="screen,projection" />
    <link type="text/css" rel="stylesheet" href="css/mycss.css" media="screen,projection" />

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
<%
    List<Categoria> lc = (List<Categoria>)session.getAttribute("ListCategorias");

    List<Chiste> lch;
    Boolean mejores = (Boolean)session.getAttribute("mejoress");
    Categoria categoriaSeleccionada = (Categoria) session.getAttribute("categoria");
    if (mejores) {
            lch = (List<Chiste>) session.getAttribute("ListChistes");
    } else {
        if (categoriaSeleccionada != null) {
            lch = categoriaSeleccionada.getChisteList();
        }else{
            lch = (List<Chiste>) session.getAttribute("ListChistes");
        }
    }
%>
<body>
    <div class="container">
        <div class="row">
            <div class="col m12 indigo lighten-3">
                <div class="row">
                    <div class="col m4 offset-m4">
                        <img class="img-responsive" src="img/logo.png" />
                    </div>
                </div>
                <div class="row pink lighten-4">
                    <% if(!mejores) {%>
                    <div class="col m5 offset-m2 valign-wrapper">
                        <div class="col m12">
                            <div class="row valign-wrapper">
                                <div class="col m3 ">
                                    <p class="right-align deep-purple-text text-darken-4 font-size-nav">Categoría: </p>
                                </div>
                                <div class="col m8 offset-m1">
                                    
                                    <form action="Controller?op=ChistesCategoria" name="jornada" method="post">
                                    <select name="idCategoria" onChange="this.form.submit()">
                                        <%if (categoriaSeleccionada == null) {
                                         %>
                                        <option value="-1" disabled selected>Elige categoria...</option>
                                        <%} else {%>
                                        <option value="-1" disabled>Elige categoria...</option>
                                        <%}%>
                                        <%
                                        for(Categoria c : lc){
                                        %>
                                        <option <%=(categoriaSeleccionada != null && categoriaSeleccionada.getId() == c.getId()) ? "selected" : ""%> value="<%=c.getId()%>"><%=c.getNombre()%></option>
                                        <%}%>

                                    </select>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col m1 valign-wrapper">
                        <p class="valign-wrapper">                            
                            <button class="valign-wrapper btn waves-effect waves-light  blue accent-4 btn modal-trigger" data-target="modaladdcategoria">
                                <i class="medium material-icons">add</i>
                            </button>
                          
                        </p>
                    </div>
                    <div class="col m3 valign-wrapper">                  
                        <form action="Controller?op=Mejores" name="formmejores" method="post">
                            <p class="valign-wrapper"><button class="valign-wrapper btn waves-effect waves-light  blue accent-4" type="submit" name="action">Mejores Chistes</button></p>
                         </form> 
                    </div>                    
                    <%}else{%>
                    <div class="col m1 valign-wrapper offset-m5">
                        <p class="valign-wrapper">                            
                            <button class="valign-wrapper btn waves-effect waves-light  blue accent-4 btn modal-trigger" data-target="modaladdcategoria">
                                <i class="medium material-icons">add</i>
                            </button>
                          
                        </p>
                    </div>
                    <div class="col m3 valign-wrapper">  
                        <form action="Controller?op=inicio" name="jornada" method="post">    
                            <p class="valign-wrapper"><button class="valign-wrapper btn waves-effect waves-light  blue accent-4" type="submit" name="action">Por Categorias</button></p>
                          
                        </form>                
                    </div>
                </div>
                <div class="row">
                    <div class="col m4 offset-m4 center-align">
                            <div class="add_cat_mar">
                                <button class="valign-wrapper btn waves-effect waves-light  blue accent-4 modal-trigger" data-target="modaladdchiste">
                                    <i class="medium material-icons">add</i>
                                </button>
                            </div>
                    </div>
                </div>
            </div>
            <%}%>
            <% if(lch != null){%>
            <div class="col m12 red lighten-5">
                <div class="row">
                    <!--FILA CHISTES-->
                    <% for(Chiste ch : lch){%>
                    <div class="col m12">
                        <div class="row red-text text-darken-4">
                            <div class="col m12">
                                <p><span class="h4p"><%=ch.getTitulo()%></span><span class="h5p">(<%=ch.getIdcategoria().getNombre()%>) - <%=ch.getMediaPuntos()%></span></p>
                            </div>
                                <div class="col m12"><span class=""><%=ch.getAdopo()%></span></div>
                            <div class="col m12">
                                <p><%=ch.getDescripcion()%></p>
                            </div>
                            <div class="col m12">
                                <span class="rating">
                                    <a href="Controller?op=Puntos&rating=1&chisteid=<%=ch.getId()%>">&#9733;</a>
                                    <a href="Controller?op=Puntos&rating=2&chisteid=<%=ch.getId()%>">&#9733;</a>
                                    <a href="Controller?op=Puntos&rating=3&chisteid=<%=ch.getId()%>">&#9733;</a>
                                    <a href="Controller?op=Puntos&rating=4&chisteid=<%=ch.getId()%>">&#9733;</a>
                                    <a href="Controller?op=Puntos&rating=5&chisteid=<%=ch.getId()%>">&#9733;</a>
                                </span>   
                            </div>
                        </div>
                    </div>
                    <%}%>
                    <!--END FILA CHISTES-->
                </div>
            </div>
           <%}%>
        </div>
    </div>
        <!-- Modal-->
        <div id="modaladdchiste" class="modal">
        <div class="modal-content">
            <h4>Add Chiste</h4>
            <div class="row">
                <form class="col s12" action="Controller?op=chistem" method="Post" name="formaddchiste">
                    <div class="row">
                        <div class="input-field col s12">
                            <input placeholder="Titulo" name="titleC" id="titleC" type="text" class="validate">
                         
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <input placeholder="Apodo" name="apodoC" id="apodoC" type="text" class="validate">
                           
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <select name="idCategoria">
                                <option value="0" disabled selected>Elige categoria...</option>
                                <% for(Categoria c : lc){%>
                                <option value="<%=c.getId()%>"><%=c.getNombre()%></option>
                                <%}%>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <textarea placeholder="Descripcion" name="descripcionC" id="descripcionC" class="materialize-textarea"></textarea>
                            
                        </div>
                    </div>
                    <div class="row">
                       <button class="btn waves-effect waves-light" type="submit" name="action">Añadir
                            <i class="material-icons right">send</i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
       <div class="modal-footer">
            <a href="#!" class="modal-close waves-effect waves-green btn-flat">Cancelar</a>
        </div>
    </div>
    <!-- -->
    <!-- Modal Categoria-->
        <div id="modaladdcategoria" class="modal">
        <div class="modal-content">
            <h4>Add Categoria</h4>
            <div class="row">
                <form class="col s12" action="Controller?op=categoriam" method="Post" name="formaddcategoria">
                    <div class="row">
                        <div class="input-field col s12">
                            <input placeholder="Titulo" name="titleC" id="titleC" type="text" class="validate">
                        </div>
                    </div>
                    <div class="row">
                       <button class="btn waves-effect waves-light" type="submit" name="action">Añadir
                            <i class="material-icons right">send</i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
       <div class="modal-footer">
            <a href="#!" class="modal-close waves-effect waves-green btn-flat">Cancelar</a>
        </div>
    </div>
    <!-- -->
    <!--JavaScript at end of body for optimized loading-->
    <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="js/materialize.min.js"></script>
    <script type="text/javascript" src="js/myjs.js"></script>
</body>

</html>
        
