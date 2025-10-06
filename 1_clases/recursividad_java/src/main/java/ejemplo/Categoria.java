package ejemplo;

import java.util.ArrayList;

public class Categoria {
    String nombre;
    ArrayList<Producto> productos = new ArrayList<>();
    ArrayList<Categoria> subCategorias = new ArrayList<>();
    
    public ArrayList<Producto> buscarProductos(){
        ArrayList<Producto> lista = new ArrayList<>();

        for (Producto producto : productos){
            if(producto.getPrecio() == 10000){
                lista.add(producto);

            }
        }
        for (Categoria categoria : subCategorias){
            lista.addAll(categoria.buscarProductos());
        }
        return lista;

    }

}
