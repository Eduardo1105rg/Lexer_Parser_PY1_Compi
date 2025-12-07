package utils;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

// Idea para esto tomada de aqui: https://codegym.cc/es/groups/posts/es.1096.java-escribir-en-un-archivo

public class ManejoArchivos {

    private static PrintWriter archivo;

    public static void iniciar(String rutaArchivo) {
        try {
            archivo = new PrintWriter(new FileWriter(rutaArchivo, false)); // Aqui se debe de poner en true para que sea
                                                                           // append y no sobreescritura.

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Funcion para el registro de los mensajes.
    public static void registrarMensaje(String mensaje) {
        if (archivo != null) {
            archivo.println(mensaje);
            archivo.flush();
        }
        // Esta parte es para mostrar el token, se puede comentar despues.
        // System.out.println(mensaje);
    }

    // Funcion para ccerar el archivo al finalizar el programa.
    public static void cerrar() {
        if (archivo != null) {
            archivo.close();
        }
    }

}
