DROP TABLE reservation CASCADE CONSTRAINT;
DROP TABLE theater CASCADE CONSTRAINT;
DROP TABLE customer CASCADE CONSTRAINT;
DROP TABLE cinema CASCADE CONSTRAINT;

CREATE TABLE cinema (
    cinemaid NUMBER PRIMARY KEY,
    cinema_name VARCHAR2(100) NOT NULL,
    cinema_location VARCHAR2(100)
);

CREATE TABLE theater (
    cinemaid NUMBER,
    theaterid NUMBER,
    movietitle VARCHAR2(200) NOT NULL,
    price NUMBER,
    seat_num NUMBER,
    CONSTRAINT pk_theater PRIMARY KEY (cinemaid, theaterid),
    CONSTRAINT fk_theater_cinema FOREIGN KEY (cinemaid) REFERENCES cinema(cinemaid)
);

CREATE TABLE customer (
    customerid NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    customer_address VARCHAR2(200)
);

CREATE TABLE reservation (
    cinemaid    NUMBER,
    theaterid   NUMBER,
    customerid  NUMBER,
    seatid      NUMBER,
    dateid      DATE,
    CONSTRAINT pk_reservation PRIMARY KEY (cinemaid, theaterid, customerid),
    CONSTRAINT fk_reservation_theater FOREIGN KEY (cinemaid, theaterid) 
                                      REFERENCES theater(cinemaid, theaterid),
    CONSTRAINT fk_reservation_customer FOREIGN KEY (customerid) 
                                       REFERENCES customer(customerid)
);

INSERT INTO cinema VALUES (1, '강남극장', '강남');
INSERT INTO cinema VALUES (2, '강동극장', '강동');
INSERT INTO cinema VALUES (3, '홍대극장', '마포');
INSERT INTO cinema VALUES (4, '신촌극장', '서대문');
INSERT INTO cinema VALUES (5, '잠실극장', '송파');

INSERT INTO theater VALUES (1, 1, '아바타', 12000, 150);
INSERT INTO theater VALUES (1, 2, '범죄도시4', 11000, 120);
INSERT INTO theater VALUES (1, 3, '파묘', 9000, 80);
INSERT INTO theater VALUES (2, 1, '듄2', 13000, 200);
INSERT INTO theater VALUES (2, 2, '건국전쟁', 8000, 60);
INSERT INTO theater VALUES (3, 1, '오펜하이머', 12000, 180);
INSERT INTO theater VALUES (3, 2, '서울의봄', 10000, 100);
INSERT INTO theater VALUES (3, 3, '밀수', 9000, 90);
INSERT INTO theater VALUES (4, 1, '콘크리트유토피아', 11000, 130);
INSERT INTO theater VALUES (4, 2, '외계+인', 7000, 70);
INSERT INTO theater VALUES (5, 1, '탑건매버릭', 13000, 250);
INSERT INTO theater VALUES (5, 2, '앤트맨', 10000, 110);

INSERT INTO customer VALUES (1, '김철수', '서울시 강남구 역삼동');
INSERT INTO customer VALUES (2, '이영희', '서울시 강동구 천호동');
INSERT INTO customer VALUES (3, '박민준', '서울시 마포구 홍대동');
INSERT INTO customer VALUES (4, '최수연', '서울시 서대문구 신촌동');
INSERT INTO customer VALUES (5, '정하늘', '서울시 송파구 잠실동');
INSERT INTO customer VALUES (6, '한지민', '서울시 강북구 수유동');
INSERT INTO customer VALUES (7, '강감찬', '서울시 용산구 이태원동');
INSERT INTO customer VALUES (8, '장내윤', '서울시 성동구 왕십리동');

INSERT INTO reservation VALUES (1, 1, 1, 15, TO_DATE('2024-10-01', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 1, 2, 23, TO_DATE('2024-10-01', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 2, 3, 7, TO_DATE('2024-10-05', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 3, 4, 11, TO_DATE('2024-10-05', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 1, 1, 50, TO_DATE('2024-10-10', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 1, 5, 88, TO_DATE('2024-10-10', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 2, 6, 3, TO_DATE('2024-10-12', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 1, 2, 77, TO_DATE('2024-10-15', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 2, 7, 45, TO_DATE('2024-10-15', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 3, 8, 62, TO_DATE('2024-10-18', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (4, 1, 3, 19, TO_DATE('2024-10-20', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (4, 2, 4, 33, TO_DATE('2024-10-20', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 1, 5, 100, TO_DATE('2024-10-22', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 1, 6, 120, TO_DATE('2024-10-22', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 2, 7, 55, TO_DATE('2024-10-25', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 2, 8, 67, TO_DATE('2024-10-25', 'YYYY-MM-DD'));
COMMIT;


SELECT  t.cinemaid,
        s.theaterid,
        s.movietitle AS movie_name,
        s.price,
        c.customer_name,
        r.seatid,
        r.dateid
FROM cinema t
JOIN theater s ON t.cinemaid = s.cinemaid
JOIN reservation r ON s.cinemaid = r.cinemaid 
                  AND s.theaterid = r.theaterid
JOIN customer c ON r.customerid = c.customerid
ORDER BY r.dateid, t.cinemaid;

-- 문제3)
------------------------------------------------
-- 1)
SELECT cinemaid FROM theater WHERE price >=9000;
-- 2)
SELECT * FROM cinema, theater WHERE cinema.cinemaid = theater.cinemaid;
-- 3)
SELECT DISTINCT t.cinema_name FROM cinema t JOIN theater s ON t.cinemaid = s.cinemaid WHERE s.price >= 10000;
-- 4)
SELECT c.customerid, c.customer_name, c.customer_address, r.cinemaid, r.theaterid, r.seatid, r.dateid 
FROM customer c LEFT OUTER JOIN reservation r ON c.customerid = r.customerid AND r.dateid > TO_DATE('2024-01-01', 'YYYY-MM-DD');
-- 5)
SELECT DISTINCT c.customer_name FROM customer c WHERE NOT EXISTS (SELECT t.cinemaid FROM cinema t WHERE t.cinema_location = '강남' MINUS SELECT r.cinemaid FROM reservation r WHERE r.customerid = c.customerid);

-- 문제4)
----------------------------------------------------
-- 1)
SELECT cinema_name, cinema_location FROM cinema;
-- 2)
SELECT movietitle FROM theater WHERE price <= 10000;
-- 3)
SELECT customer_name, customer_address FROM customer;
-- 4)
SELECT s.movietitle FROM cinema t JOIN theater s ON t.cinemaid = s.cinemaid WHERE t.cinema_location = '강남';
-- 5)
SELECT c.customer_name FROM customer c WHERE NOT EXISTS (SELECT t.cinemaid FROM cinema t WHERE t.cinema_location = '강남' MINUS SELECT r.cinemaid FROM reservation r WHERE r.customerid = c.customerid);
-- 단순 질의)
-------------------------------------------------------------------

-- 1) 극장테이블에서 극장이름, 위치를 추출하시오
SELECT cinema_name, cinema_location FROM cinema;

-- 2)극장 테이블에서 위치가 '서울'인 극장의 극장이름을 조회하시오.
SELECT cinema_name FROM cinema WHERE cinema_location = '서울';

-- 3) 상영관 테이블에서 가격이 10000원 이상인 상영관의 극장번호, 상영관번호, 영화제목을 조회하시오.
SELECT cinemaid, theaterid, movietitle FROM theater WHERE price >= 10000;

-- 4) 상영관 테이블에서 영화제목별 상영관 수를 조회하시오.
SELECT movietitle, COUNT(theaterid) FROM theater GROUP BY movietitle;

-- 5) 예약 테이블에서 날짜가 '2024-01-01'인 모든 예약 정보를 조회하시오.
SELECT * FROM reservation WHERE dateid = TO_DATE('2024-01-01', 'YYYY-MM-DD');

-- 6) 고객 테이블에서 주소별 고객 수를 조회하시오.
SELECT customer_address, COUNT(customerid) FROM customer GROUP BY customer_address;

-- 7) 상영관 테이블에서 좌석수가 가장 많은 상영관의 극장번호와 상영관번호를 조회하시오.
SELECT cinemaid, theaterid FROM theater WHERE seat_num = (SELECT MAX(seat_num) FROM theater);

-- 8)예약 테이블에서 고객번호별 예약 횟수를 조회하시오.
SELECT customerid, COUNT(*) FROM reservation GROUP BY customerid;

-- 9) 상영관 테이블에서 극장번호별 평균 가격을 조회하시오.
SELECT cinemaid, AVG(price) FROM theater GROUP BY cinemaid;

-- 10) 고객 테이블에서 이름이 '김'으로 시작하는 고객의 이름과 주소를 조회하시오.
SELECT customer_name, customer_address FROM customer where customer_name LIKE '김%';

-- 조인 질의)
--------------------------------------------------------------------------------
-- 11) 극장과 상영관 테이블을 조인하여 극장이름과 해당 극장의 영화제목을 조회하시오.
SELECT c.cinema_name, t.movietitle FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid;

-- 12) 극장, 상영관, 예약 테이블을 조인하여 극장이름, 영화제목, 예약 날짜를 조회하시오.
SELECT c.cinema_name, t.movietitle, r.dateid FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid;

-- 13) 고객과 예약 테이블을 조인하여 고객 이름과 해당 고객의 예약 날짜를 조회하시오.
SELECT c.customer_name, r.dateid FROM customer c JOIN reservation r ON c.customerid = r.customerid;

-- 14) 극장, 상영관, 예약, 고객 테이블을 모두 조인하여 극장이름, 영화제목, 고객이름, 좌석번호를 조회하시오.
SELECT ci.cinema_name, t.movietitle, cu.customer_name, r.seatid FROM cinema ci JOIN theater t ON ci.cinemaid = t.cinemaid JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid JOIN customer cu ON r.customerid = cu.customerid;

-- 15) 상영관과 예약 테이블을 조인하여 영화제목별 총 예약 수를 조회하시오.
SELECT t.movietitle, COUNT(*) FROM theater t JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid GROUP BY t.movietitle;

-- 16) 극장과 상영관 테이블을 조인하여 위치가 '서울'인 극장에서 상영 중인 영화제목과 가격을 조회하시오.
SELECT t.movietitle, t.price FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid WHERE c.cinema_location = '서울';

-- 17) 고객과 예약 테이블을 LEFT JOIN하여 예약이 한 건도 없는 고객의 이름을 조회하시오.
SELECT c.customer_name FROM customer c LEFT JOIN reservation r ON c.customerid = r.customerid WHERE r.customerid IS NULL;

-- 18) 극장, 상영관, 예약 테이블을 조인하여 극장별 총 예약 수를 조회하시오.
SELECT c.cinema_name, COUNT(r.customerid) FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid GROUP BY c.cinema_name;

-- 19) 상영관과 예약 테이블을 조인하여 가격이 15000원 이상인 상영관을 예약한 고객번호와 영화제목을 조회하시오.
SELECT r.customerid, t.movietitle FROM theater t JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid WHERE t.price >= 15000;

-- 20) 극장, 상영관, 예약, 고객 테이블을 조인하여 고객별 총 예약 횟수와 이름을 조회하시오.
SELECT cu.customer_name, COUNT(r.customerid) FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid JOIN customer cu ON r.customerid = cu.customerid GROUP BY cu.customer_name;

-- 부속 질의)

-- 21) 예약 테이블에서 가장 많은 예약이 발생한 극장번호를 조회하시오.
SELECT cinemaid FROM reservation GROUP BY cinemaid HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM reservation GROUP BY cinemaid);

-- 22) 고객 테이블에서 예약 테이블에 예약 기록이 있는 고객의 이름과 주소를 조회하시오. (IN 사용)
SELECT customer_name, customer_address FROM customer WHERE customerid IN (SELECT customerid FROM reservation);

-- 23) 극장 테이블에서 상영관이 3개 이상 등록된 극장의 극장이름을 조회하시오.
SELECT cinema_name FROM cinema WHERE cinemaid IN (SELECT cinemaid FROM theater GROUP BY cinemaid HAVING COUNT(theaterid) >= 3);

-- 24) 상영관 테이블에서 전체 상영관 평균 가격보다 비싼 상영관의 영화제목과 가격을 조회하시오.
SELECT movietitle, price FROM theater WHERE price > (SELECT AVG(price) FROM theater);

-- 25) 고객 테이블에서 예약 테이블에 예약 기록이 전혀 없는 고객의 이름을 조회하시오. (NOT IN 사용)
SELECT customer_name FROM customer WHERE customerid NOT IN (SELECT customerid FROM reservation);

-- 26) 극장 테이블에서 예약 테이블에 예약된 적이 없는 극장의 극장이름을 조회하시오.
SELECT cinema_name FROM cinema WHERE cinemaid NOT IN (SELECT cinemaid FROM reservation);

-- 27) 예약 테이블에서 예약 횟수가 전체 고객 평균 예약 횟수보다 많은 고객번호를 조회하시오.
SELECT customerid FROM reservation GROUP BY customerid HAVING COUNT(*) > (SELECT AVG(COUNT(*)) FROM reservation GROUP BY customerid);

-- 28) 상영관 테이블에서 좌석수가 가장 적은 상영관이 속한 극장의 극장이름을 조회하시오.
SELECT c.cinema_name FROM cinema c JOIN theater t ON c.cinemaid = t.cinemaid WHERE t.seat_num = (SELECT MIN(seat_num) FROM theater);

-- 29) 예약 테이블에서 '2024-01-01'에 예약이 발생한 상영관의 영화제목을 조회하시오.
SELECT DISTINCT t.movietitle FROM theater t JOIN reservation r ON t.cinemaid = r.cinemaid AND t.theaterid = r.theaterid WHERE r.dateid = TO_DATE('2024-01-01', 'YYYY-MM-DD');

-- 30) 고객 테이블에서 두 번 이상 예약한 고객의 이름을 조회하시오.
SELECT customer_name FROM customer WHERE customerid IN (SELECT customerid FROM reservation GROUP BY customerid HAVING COUNT(*) >= 2);

-- 상관부속질의)

-- 31) 고객 테이블에서 예약 테이블에 본인 고객번호로 예약 기록이 존재하는 고객의 이름을 조회하시오. (EXISTS 사용)
SELECT c.customer_name FROM customer c WHERE EXISTS (SELECT 1 FROM reservation r WHERE r.customerid = c.customerid);

-- 32) 상영관 테이블에서 같은 극장 내 상영관들의 평균 가격보다 비싼 상영관의 영화제목과 가격을 조회하시오.
SELECT t1.movietitle, t1.price FROM theater t1 WHERE t1.price > (SELECT AVG(t2.price) FROM theater t2 WHERE t2.cinemaid = t1.cinemaid);

-- 33) 극장 테이블에서 해당 극장에 예약된 건수가 5건 이상인 극장의 극장이름을 조회하시오.
SELECT cinema_name FROM cinema WHERE cinemaid IN (SELECT cinemaid FROM reservation GROUP BY cinemaid HAVING COUNT(*) >= 5);

-- 34) 고객 테이블에서 예약 테이블에 본인 고객번호로 예약한 좌석번호가 'A1'인 기록이 존재하는 고객의 이름을 조회하시오.
SELECT c.customer_name FROM customer c WHERE EXISTS (SELECT 1 FROM reservation r WHERE r.customerid = c.customerid AND r.seatid = 'A1');

-- 35) 상영관 테이블에서 해당 상영관에 예약된 기록이 하나도 없는 상영관의 영화제목을 조회하시오. (NOT EXISTS 사용)
SELECT t.movietitle FROM theater t WHERE NOT EXISTS (SELECT 1 FROM reservation r WHERE r.cinemaid = t.cinemaid AND r.theaterid = t.theaterid);

-- 36) 예약 테이블에서 같은 고객이 동일 날짜에 두 건 이상 예약한 고객번호와 날짜를 조회하시오.
SELECT customerid, dateid FROM reservation GROUP BY customerid, dateid HAVING COUNT(*) >= 2;

-- 37) 극장 테이블에서 소속된 모든 상영관의 가격이 10000원 이상인 극장의 극장이름을 조회하시오. (NOT EXISTS 활용)
SELECT c.cinema_name FROM cinema c WHERE NOT EXISTS (SELECT 1 FROM theater t WHERE t.cinemaid = c.cinemaid AND t.price < 10000);

-- 38) 고객 테이블에서 예약 테이블에 서로 다른 극장에 2곳 이상 예약한 고객의 이름을 조회하시오.
SELECT customer_name FROM customer WHERE customerid IN (SELECT customerid FROM reservation GROUP BY customerid HAVING COUNT(DISTINCT cinemaid) >= 2);

-- 39) 상영관 테이블에서 같은 극장 내에서 좌석수가 가장 많은 상영관의 영화제목을 조회하시오.
SELECT t1.movietitle FROM theater t1 WHERE t1.seat_num = (SELECT MAX(t2.seat_num) FROM theater t2 WHERE t2.cinemaid = t1.cinemaid);

-- 40) 고객 테이블에서 가장 최근 날짜에 예약한 고객의 이름을 조회하시오.
SELECT customer_name FROM customer WHERE customerid IN (SELECT customerid FROM reservation WHERE dateid = (SELECT MAX(dateid) FROM reservation));