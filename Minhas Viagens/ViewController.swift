//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by Pedro Lucas de Almeida on 14/12/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var locationManager = CLLocationManager()
    var armazenamentoDados = ArmazenamentoDados()
    var viagem:Viagem!
    var indiceSelecionado: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let indice = indiceSelecionado {
            if indice == -1 {//adicionar
                locationManagerConfig(locationManager)
            }else{//mostrar
                exibeAnotacao(viagem:viagem)
            }
        }
        
        let gestureRecon = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        gestureRecon.minimumPressDuration = 2
        
        mapa.addGestureRecognizer(gestureRecon)
    }
    

    func locationManagerConfig(_ lm:CLLocationManager){
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacao = locations.last!
        
        centralizaLocal(latitude: localizacao.coordinate.latitude, longitude: localizacao.coordinate.longitude)
    }
    
    func exibeAnotacao(viagem:Viagem?){
        
        if let localViagem = viagem?.localNome
        {
            if let latitudeS = viagem?.latitude
            {
                if let longitudeS = viagem?.longitude
                {
                    if let latitude = Double(latitudeS)
                    {
                        if let longitude = Double(longitudeS)
                        {
                            let annotation = MKPointAnnotation()
                            
                            annotation.coordinate.latitude = latitude
                            annotation.coordinate.longitude = longitude
                            
                            annotation.title = localViagem
                            self.mapa.addAnnotation(annotation)
                            
                            centralizaLocal(latitude: latitude, longitude: longitude)
                        }
                    }
                }
            }
        }
        
    }
    
    func centralizaLocal (latitude: Double, longitude: Double)
    {
        let coordinated: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let spanVar: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01)
        let regiao:MKCoordinateRegion = MKCoordinateRegion(center: coordinated, span: spanVar)
        self.mapa.setRegion(regiao, animated: true)
    }
    
    @objc func marcar(gesture: UIGestureRecognizer){
        if(gesture.state == UIGestureRecognizer.State.began)
        {
            let selectedPoint = gesture.location(in: self.mapa)
            let coordinates = mapa.convert(selectedPoint, toCoordinateFrom: self.mapa)
            
            let localization = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

            var enderecoCompleto = "Endereço não encontrado!"
            
            //recuperar endereco
            CLGeocoder().reverseGeocodeLocation(localization, completionHandler : { (local, erro) in
                
                if erro == nil {
                    if let dadosLocal = local?.first {
                        if let nome = dadosLocal.name {
                            enderecoCompleto = nome
                        }else{
                            if let endereco = dadosLocal.thoroughfare {
                                enderecoCompleto = endereco
                            }
                        }
                    }
                    
                    //salvando os dados no dispositivo
                    
                    self.armazenamentoDados.salvarViagem(enderecoCompleto, String(coordinates.latitude), String(coordinates.longitude))
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate.latitude = coordinates.latitude
                    annotation.coordinate.longitude = coordinates.longitude
                    
                    annotation.title = enderecoCompleto
                    self.mapa.addAnnotation(annotation)

                }else{
                    print(erro)
                    
                }
            })
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedWhenInUse) {
            let alertController = UIAlertController(title: "Permissão de Localização",
                                                    message: "Sem permissão, sem APP", preferredStyle: .alert)
            let acaoConfigs = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configs = NSURL(string: UIApplication.openSettingsURLString ){
                    UIApplication.shared.open(configs as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertController.addAction(acaoConfigs)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

