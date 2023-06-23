ITEM.name = "Banking book"
ITEM.desc = "Banking book with information about banking accounts."
ITEM.model = "models/props_lab/binderredlabel.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Read = {
    onRun = function( self )
        local client = self.player

        if client:getChar():hasFlags(BANKING_BOOK_FLAG) then
            netstream.Start(client, 'Banking::OpenBook')
        end;
        
        return false
    end,

    onCanRun = function( self )
        local client = self.player
        return client:getChar():hasFlags(BANKING_BOOK_FLAG);
    end
}
