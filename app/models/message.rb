class Message < ActiveRecord::Base
  attr_accessor :full_name, :phone

  belongs_to :client
  belongs_to :project
  belongs_to :conversation
  has_many :message_receipts


  before_create :get_sender
  after_create :create_receipts 

   

   def find_sender
    message_receipts.where(:mailbox_type == "Sent").first.sender
   end



   def get_sender
      unless source == "CONTACT_FORM_USER"
       	Contact.find_or_create_by(:email => email) do |contact|
     		 contact.full_name = full_name
        end
      else 
        User.find_by(:email=> email)
      end
  end
   
   
   def get_receiver
      User.find(1)
   end 

   

   private


   def create_receipts 
   		create_receipt_for_recipients 
   		create_receipt_for_sender
   end 
 
   def create_receipt_for_recipients
   	 MessageReceipt.create(
      message: self,
      receivable_id: get_receiver.id, 
      receivable_type: get_receiver.class,
      sender_id: get_sender.id,
      sender_type: get_sender.class,
      read: false, 
      mailbox_type: "Inbox"

      
    )
   end 
   def create_receipt_for_sender
   	 MessageReceipt.create(
      message: self,
      receivable_id: get_sender.id,
      receivable_type: get_sender.class,
      sender_id: get_sender.id,
      sender_type: get_sender.class,
      read: false, 
      mailbox_type: "Sent"

      
    )
   end 

end

