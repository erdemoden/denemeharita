# denemeharita
Bu projede haritalar ile çalıştım uygulama ilk açıldığında harita sizin bulunduğunuz konuma zoomluyor ve haritada mavi işaretle kendinizi görebiliyorsunuz.
Açılan haritada kendinizin bulunduğu yer dışında herhangi bir yere 3 saniye basılı tutarsanız bir annotation oluşturursunuz bu annotationların konumları aynı zamanda coredatada tutulur ve uygulamayı tekrar açtığınızda coredatadan çekilen konumlarla annotationlar tekrar oluşturulur.Eğer oluşturduğunuz bir annotationa bir kere basarsanız segue ile yeni bir view controller açılır (present as popover olarak) ve açılan view controllerdaki delete annotation butonuna basarsanız tıkladığınız annotation coredatadan silinir.Tekrar haritaya döndüğünüzde coredata verileri tekrar yüklenir ve annotation silinmiş olur.

