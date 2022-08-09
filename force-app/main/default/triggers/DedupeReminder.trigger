trigger DedupeReminder on Account (after insert) {

    for(Account acc : Trigger.new){

        Case c = new Case();
        c.Subject = 'Dedupe this Account';
        c.OwnerId = '0058a00000KcL4HAAV';
        c.AccountId = acc.Id;
        insert c;
    }
}