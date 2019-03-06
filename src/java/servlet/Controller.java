/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import entities.Categoria;
import entities.Chiste;
import entities.Puntos;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jpautil.JPAUtil;

/**
 *
 * @author Yoel
 */
@WebServlet(name = "Controller", urlPatterns = {"/Controller"})
public class Controller extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher;
        
        String op;
        String sql;
        Query query;
        EntityManager em = null;
        Categoria cat;
        if (em == null) {
            em = JPAUtil.getEntityManagerFactory().createEntityManager();
            session.setAttribute("em", em);
        }

        op = request.getParameter("op");
        
        if (op.equals("inicio")) {
            //Sentencia JPQL
            session.setAttribute("mejoress", false);
            sql = "select c from Categoria c";
            //Creamos query pasando la sentencia
            query = em.createQuery(sql);
            session.setAttribute("categoria",null);
            session.setAttribute("ListChistes", null);
            List<Categoria> lc = query.getResultList();           
            session.setAttribute("ListCategorias", lc);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("ChistesCategoria")){
            Short id = Short.valueOf(request.getParameter("idCategoria"));
            if (id==-1){
                session.setAttribute("categoria",null);
            }else {
                session.setAttribute("categoria",em.find(Categoria.class, id));
            }
 
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);

        }else if(op.equals("Puntos")){
            BigDecimal bd = BigDecimal.valueOf(Double.parseDouble(request.getParameter("rating")));
            
            Short idC = Short.parseShort(request.getParameter("chisteid"));
           
            Chiste c = em.find(Chiste.class,idC);
            
            Puntos p = new Puntos(1);
            p.setPuntos(bd);
            p.setIdchiste(c);
            
            EntityTransaction transaction = em.getTransaction();
            transaction.begin();
            em.persist(p);      
            transaction.commit();
            em.refresh(c);
            cat = em.find(Categoria.class, c.getIdcategoria().getId());
            em.refresh(cat);
            em.getEntityManagerFactory().getCache().evictAll();
            
            if((Boolean)session.getAttribute("mejoress")){               
                sql = "select p.idchiste from Puntos p group by p.idchiste order by avg(p.puntos) DESC";
                query = em.createQuery(sql);
                session.setAttribute("ListChistes",query.getResultList());
            }else{
               cat = (Categoria) session.getAttribute("categoria");
               session.setAttribute("categoria",cat);
            }

            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        
        
        }else if(op.equals("Mejores")){
             
            session.setAttribute("mejoress", true);
            
            sql = "select p.idchiste from Puntos p group by p.idchiste order by avg(p.puntos) DESC";
            //Creamos query pasando la sentencia
            query = em.createQuery(sql);
            //Sacamos resultado ejecutando la query
            session.setAttribute("categoria",null);
            List<Chiste> lch = query.getResultList();
            session.setAttribute("ListChistes", lch);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        
        }else if(op.equals("chistem")){
        
            Chiste c = new Chiste();
             c.setAdopo(request.getParameter("apodoC"));
             c.setId(Short.parseShort("0"));
             c.setTitulo(request.getParameter("titleC"));
             c.setIdcategoria(em.find(Categoria.class, Short.parseShort(request.getParameter("idCategoria"))));
             c.setDescripcion(request.getParameter("descripcionC"));
             List<Puntos> lp = new ArrayList<>();
          
             c.setPuntosList(lp);
            cat = em.find(Categoria.class, Short.parseShort(request.getParameter("idCategoria")));
            EntityTransaction transaction = em.getTransaction();
            transaction.begin();
            em.persist(c);      
            transaction.commit();
            em.getEntityManagerFactory().getCache().evictAll();
            cat = em.find(Categoria.class, cat.getId());
            em.refresh(cat);
                
            session.setAttribute("categoria", cat);
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        
        }else if(op.equals("categoriam")){
        
            Categoria c = new Categoria();
            c.setChisteList(new ArrayList<>());
            c.setId((short)0);
            c.setNombre((String)request.getParameter("titleC"));
            
            EntityTransaction transaction = em.getTransaction();
            transaction.begin();
            em.persist(c);      
            transaction.commit();
            em.getEntityManagerFactory().getCache().evictAll();
            
            sql = "select c from Categoria c";
            query = em.createQuery(sql);
            List<Categoria> lc = query.getResultList();           
            session.setAttribute("ListCategorias", lc);
                
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        
        }
        
    }

  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
