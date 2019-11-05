

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventos : [Evento] = []

    @IBOutlet weak var tvNombreEvento: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("http://localhost:8888/wordpress/wp-json/wp/v2/eventos").responseJSON{
        response in
        switch(response.result)
        {
        case .success(let datos) : if let arregloEvenntos = datos as? NSArray {
            for evento in arregloEvenntos{
               if let diccionarioEvento = evento as? NSDictionary
               {
                let nuevoElemento = Evento(diccionario : diccionarioEvento)
                self.eventos.append(nuevoElemento)
                   }
                 }
            
            self.tvNombreEvento.reloadData()
            }
        case .failure(_) : print("Algo salio mal")
        
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellEvento") as? CeldaEventoController
        celda?.lblNombre.text = eventos[indexPath.row].nombre
        celda?.lblFecha.text = eventos[indexPath.row].fecha
        
        AF.request(eventos[indexPath.row].urlFlyer).responseImage{
            response in
            switch(response.result){
            case .success(let data): celda?.imgFlyer.image = data
            case .failure(_) : print("Algo salio mal")
            }
        }
        
        return celda!
    }


}

