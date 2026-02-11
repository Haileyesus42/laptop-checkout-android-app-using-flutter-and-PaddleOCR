import cv2
import re
import time
import logging
from paddleocr import PaddleOCR

logging.getLogger("ppocr").setLevel(logging.WARNING)

class LaptopSerialScanner:
    def __init__(self):
        self.ocr = PaddleOCR(
            text_detection_model_name='PP-OCRv5_mobile_det',
            text_recognition_model_name='PP-OCRv5_mobile_rec',
            use_doc_unwarping=False,
            use_doc_orientation_classify=False,
            use_textline_orientation=False,
            enable_mkldnn=True,
            cpu_threads=10,
            lang='en',
            ocr_version='PP-OCRv5',
            text_det_limit_type='max',
            text_det_limit_side_len=960
        )

        self.patterns = [
            r'\b[A-Z0-9]{7}\b',
            r'\b[A-Z0-9]{8}\b',
            r'\b[A-Z0-9]{10}\b',
            r'\b[A-Z0-9]{11,12}\b',
            r'\b[A-Z0-9]{15}\b'
        ]

        self.anchors = ["S/N", "SN", "SERVICE", "TAG", "SERIAL", "NO", "SSN"]

    def _clean(self, text):
        return re.sub(r'[^A-Z0-9]', '', text.upper())

    def scan(self, img_path):
        frame = cv2.imread(img_path)
        if frame is None:
            return None

        results = self.ocr.predict(frame)
        
        if not results:
            return None

        raw_texts = results[0]['rec_texts']
        detected_sn = None

        for i, text in enumerate(raw_texts):
            original_clean = text.upper().strip()
            
            parts = re.split(r'[:\s]+', original_clean)
            for part in parts:
                clean_part = self._clean(part)
                for pattern in self.patterns:
                    if re.fullmatch(pattern, clean_part) and clean_part not in self.anchors:
                        detected_sn = clean_part
                        break
                if detected_sn: break
            
            if not detected_sn:
                if any(anchor in original_clean for anchor in self.anchors):
                    if i + 1 < len(raw_texts):
                        next_text = self._clean(raw_texts[i+1])
                        for pattern in self.patterns:
                            if re.fullmatch(pattern, next_text):
                                detected_sn = next_text
                                break
            
            if detected_sn: break

        return detected_sn

if __name__ == "__main__":
    scanner = LaptopSerialScanner()
    img_path = '/home/haile/ai/projects/portfolio/laptop_checkout/exps/sn3.png'
    result = scanner.scan(img_path)
    if result:
        print(result)