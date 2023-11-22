from config.settings import MINIO_BUCKET

def parsing_roomdb_to_dict(roomdb_obj_list):
    dict_obj_list = []
    for obj in roomdb_obj_list:
        obj_dict = {
                'room_id': obj.room_id,
                'room_name': obj.room_name,
                'capacity': obj.capacity,
                'facility': obj.facility,
                'image_url': f'/object/{MINIO_BUCKET}/{obj.image_url}',
                'description': obj.description,
                'available': obj.available 
               }
        
        dict_obj_list.append(obj_dict)
    
    return dict_obj_list
