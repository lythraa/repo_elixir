package taller_entrada_datos;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.swing.JOptionPane;

public class LongitudPalabra {
    public static void main(String[] args) {
        try {
            String palabra = JOptionPane.showInputDialog("Digite una palabra:");

            // ProcessBuilder permite crear y ejecutar procesos del sistema operativo desde Java.
            // Aquí se construye el comando: elixir LongitudPalabra.exs <palabra>
            // Esto ejecuta el script de Elixir y le pasa la palabra como argumento.
            ProcessBuilder pb = new ProcessBuilder("elixir", "LongitudPalabra.exs", palabra);

            // Redirige el flujo de error al flujo de salida estándar, así puedes leer ambos por el mismo canal
            pb.redirectErrorStream(true);

            // Inicia el proceso (ejecuta el comando)
            Process process = pb.start();

            // Crea un BufferedReader para leer la salida del proceso (lo que imprime el script de Elixir)
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

            // Lee la primera línea de la salida (que será la cantidad de letras)
            String resultado = reader.readLine();

            // Muestra el resultado en un cuadro de diálogo
            JOptionPane.showMessageDialog(null, "Cantidad de letras: " + resultado);
        } catch (Exception e) {
            // Si ocurre algún error, imprime la traza para depuración
            e.printStackTrace();
        }
    }
}
