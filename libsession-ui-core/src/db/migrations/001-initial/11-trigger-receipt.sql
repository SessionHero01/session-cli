-- Trigger to update the status of a message when a receipt message is received.
CREATE TRIGGER message_update_receipt
    AFTER INSERT ON messages
    WHEN NEW.content->>'$.receiptMessage.type' IN ('DELIVERY', 'READ')
    BEGIN
        -- Update the receipt status of the message. Note that you can only go from NULL to DELIVERY, or from DELIVERY to READ.
        UPDATE messages
        SET receipt = CASE
            WHEN receipt IS NULL THEN NEW.content->>'$.receiptMessage.type'
            WHEN NEW.content->>'$.receiptMessage.type' = 'READ' THEN 'READ'
            ELSE receipt
        END
        WHERE created_at IN (SELECT CAST(value as INTEGER) FROM json_each(NEW.content -> '$.receiptMessage.timestamp'));
    END;