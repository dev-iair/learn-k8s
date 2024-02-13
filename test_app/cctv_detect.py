import cv2
from multiprocessing import Process, Manager 
from ultralytics import YOLO
import time
import json
import logging

logger = logging.getLogger('logger')
logger.setLevel(logging.DEBUG)  # Set the logging level to DEBUG

formatter = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s')
formatter.datefmt = '%Y-%m-%d %H:%M:%S'

stream_handler = logging.StreamHandler()
stream_handler.setFormatter(formatter)
stream_handler.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(message)s')

logger.addHandler(stream_handler)

class_name = {
    0: 'person',
    1: 'bicycle',
    2: 'car',
    3: 'motorcycle',
    5: 'bus',
    7: 'truck'
}

cctvs = {
    0: "rtsp://210.99.70.120:1935/live/cctv005.stream",
    1: "rtsp://210.99.70.120:1935/live/cctv007.stream",
    2: "rtsp://210.99.70.120:1935/live/cctv013.stream",
}
def log_fommater(json_data):
    log_str = f"cctv={json_data['cctv']}"
    for key, value in json_data.items():
        if key != 'cctv':
            log_str += f" {key}={value}"
    return log_str

def get_frame(no, frame_dict):
    url = cctvs[no]
    cap = cv2.VideoCapture(url)
    while True:
        ret, frame = cap.read()
        frame_dict[no] = frame

def detecting(cctvs, frame_dict):
    model = YOLO('/app/yolov8s-coco.pt')

    def object_count(data):
        temp_dict = dict()

        for name in class_name.values():
            temp_dict[name] = 0
        for item in data:
            temp_dict[item['name']] += 1

        return temp_dict

    while True:
        for no in cctvs:
            if no in frame_dict.keys():
                results = model.predict(frame_dict[no], iou=0.5, classes=[0,1,2,3,5,7], verbose=False)
                result_json = results[0].tojson()
                result_count = object_count(json.loads(result_json))
                result_count['cctv'] = no
                logger.info(log_fommater(result_count))
                time.sleep(1/3)

processes = list()
manager = Manager()
frame_dict = manager.dict()

for cctv_no in cctvs.keys():
    t = Process(name='get_frame', target=get_frame, args=(cctv_no,frame_dict,))
    processes.append(t)
    t.start()

detect_t = Process(name='detecting', target=detecting, args=(cctvs.keys(),frame_dict,))
processes.append(detect_t)
detect_t.start()

for process in processes:
    process.join()