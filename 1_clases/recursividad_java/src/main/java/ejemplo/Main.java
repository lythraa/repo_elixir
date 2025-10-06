package ejemplo;

import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
    ArrayList<Integer> lista = new ArrayList<>();
    for (int i = 0; i < lista.size(); i++) {
        System.out.println(lista.get(i));
    }
    imprimirRecursivo(lista);

    }

    private static void imprimirRecursivo(ArrayList<Integer> lista) {
        if(lista.size() == 0){
            return;
        }
        System.out.println(lista.get(0));
        lista.remove(0);
        imprimirRecursivo(lista);
    }

    private static void imprimirRecursivoRobinson(ArrayList<Integer> lista, int indice) {
        if(indice == lista.size()){
            return;
        } else {
            System.out.println(lista.get(indice));
            imprimirRecursivoRobinson(lista, indice + 1);
            System.out.println(lista.get(indice));
        }
        
    }
}