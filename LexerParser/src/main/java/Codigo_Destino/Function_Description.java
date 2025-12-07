package Codigo_Destino;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import simbolos.Cuad;

/**
 * Esta clase representa un almacenamiento para el procesamiento de una funcion,
 * es decir mientras en el tc se encuentre una
 * funcion se procesara y se ira creando una descripcion de esta con el fin de
 * que sea mas facil procesarla.
 */

public class Function_Description {
    public String nombre;
    public List<String> params = new ArrayList<>();
    public Map<String, Integer> estructura = new HashMap<>();
    public List<Cuad> instrucciones = new ArrayList<>();
    public int tamanoStack = 4; // Hacemos que empiece en 4 para que el ra quede en el punto 0.

    public Function_Description(String name) {
        this.nombre = name;
    }

    public void addParam(String nombreParam) {
        params.add(nombreParam);
        // asignar offset en stack (ejemplo simple: cada param ocupa 4 bytes)
        estructura.put(nombreParam, tamanoStack);
        tamanoStack += 4;
    }

    public void addLocal(String nombreVar) {
        estructura.put(nombreVar, tamanoStack);
        tamanoStack += 4;
    }

    public void mostrar_estructura() {
        System.out.println("Estructura de la funcion " + nombre);
        System.out.println("Params: " + params);
        System.out.println("Estructura: " + estructura);
        System.out.println("Tamano del stack: " + tamanoStack);
    }
}
