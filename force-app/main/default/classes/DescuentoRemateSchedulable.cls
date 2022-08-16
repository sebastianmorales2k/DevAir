public with sharing class DescuentoRemateSchedulable implements Schedulable{
    public void execute(SchedulableContext context){
        descuentoRemateBatch descuento = new descuentoRemateBatch();
        ID batchprocessid = Database.executeBatch(descuento);
    }
}
