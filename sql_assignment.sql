-- faculty (Khoa trong trường)
create table faculty (
	id number primary key,
	name nvarchar2(30) not null
);

-- subject (Môn học)
create table subject(
	id number primary key,
	name nvarchar2(100) not null,
	lesson_quantity number(2,0) not null -- tổng số tiết học
);

-- student (Sinh viên)
create table student (
	id number primary key,
	name nvarchar2(30) not null,
	gender nvarchar2(10) not null, -- giới tính
	birthday date not null,
	hometown nvarchar2(100) not null, -- quê quán
	scholarship number, -- học bổng
	faculty_id number not null constraint faculty_id references faculty(id) -- mã khoa
);

-- exam management (Bảng điểm)
create table exam_management(
	id number primary key,
	student_id number not null constraint student_id references student(id),
	subject_id number not null constraint subject_id references subject(id),
	number_of_exam_taking number not null, -- số lần thi (thi trên 1 lần được gọi là thi lại) 
	mark number(4,2) not null -- điểm
);

-- subject
insert into subject (id, name, lesson_quantity) values (1, n'Cơ sở dữ liệu', 45);
insert into subject values (2, n'Trí tuệ nhân tạo', 45);
insert into subject values (3, n'Truyền tin', 45);
insert into subject values (4, n'Đồ họa', 60);
insert into subject values (5, n'Văn phạm', 45);


-- faculty
insert into faculty values (1, n'Anh - Văn');
insert into faculty values (2, n'Tin học');
insert into faculty values (3, n'Triết học');
insert into faculty values (4, n'Vật lý');


-- student
insert into student values (1, n'Nguyễn Thị Hải', n'Nữ', to_date('19900223', 'YYYYMMDD'), 'Hà Nội', 130000, 2);
insert into student values (2, n'Trần Văn Chính', n'Nam', to_date('19921224', 'YYYYMMDD'), 'Bình Định', 150000, 4);
insert into student values (3, n'Lê Thu Yến', n'Nữ', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 150000, 2);
insert into student values (4, n'Lê Hải Yến', n'Nữ', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 170000, 2);
insert into student values (5, n'Trần Anh Tuấn', n'Nam', to_date('19901220', 'YYYYMMDD'), 'Hà Nội', 180000, 1);
insert into student values (6, n'Trần Thanh Mai', n'Nữ', to_date('19910812', 'YYYYMMDD'), 'Hải Phòng', null, 3);
insert into student values (7, n'Trần Thị Thu Thủy', n'Nữ', to_date('19910102', 'YYYYMMDD'), 'Hải Phòng', 10000, 1);


-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 2, 2, 6);
insert into exam_management values (3, 1, 3, 1, 5);
insert into exam_management values (4, 2, 1, 1, 4.5);
insert into exam_management values (5, 2, 3, 1, 10);
insert into exam_management values (6, 2, 5, 1, 9);
insert into exam_management values (7, 3, 1, 2, 5);
insert into exam_management values (8, 3, 3, 1, 2.5);
insert into exam_management values (9, 4, 5, 2, 10);
insert into exam_management values (10, 5, 1, 1, 7);
insert into exam_management values (11, 5, 3, 1, 2.5);
insert into exam_management values (12, 6, 2, 1, 6);
insert into exam_management values (13, 6, 4, 1, 10);

/********* A. BASIC QUERY *********/

-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần
--      b. giới tính
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
SELECT *
FROM student
ORDER BY id, gender, birthday, scholarship DESC;


-- 2. Môn học có tên bắt đầu bằng chữ 'T'
SELECT *
FROM subject
WHERE name LIKE 'T%';

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
SELECT *
FROM student
WHERE SUBSTR(name, -1) = 'i';

-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
SELECT *
FROM faculty
WHERE SUBSTR(name, 2, 1) = 'n';

-- 5. Sinh viên trong tên có từ 'Thị'
SELECT *
FROM student
WHERE name LIKE '%Thị%';

-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
SELECT *
FROM student
WHERE SUBSTR(name, 1, 1) BETWEEN 'a' AND 'm'
ORDER BY name;

-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
SELECT *
FROM student
WHERE scholarship > 100000
ORDER BY faculty_id DESC;

-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
SELECT *
FROM student
WHERE scholarship >= 150000 AND hometown = 'Hà Nội';

-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
SELECT *
FROM student
WHERE birthday BETWEEN TO_DATE('19910101', 'YYYYMMDD') AND TO_DATE('19920605', 'YYYYMMDD');

-- 10. Những sinh viên có học bổng từ 80000 đến 150000
SELECT *
FROM student
WHERE scholarship BETWEEN 80000 AND 150000;

-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
SELECT *
FROM subject
WHERE lesson_quantity > 30 AND lesson_quantity < 45;



-------------------------------------------------------------------

/********* B. CALCULATION QUERY *********/

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
SELECT id, gender, faculty_id, 
       CASE 
           WHEN scholarship > 500000 THEN 'Học bổng cao'
           ELSE 'Mức trung bình'
       END AS scholarship_level
FROM student;
		
-- 2. Tính tổng số sinh viên của toàn trường
SELECT COUNT(*)
FROM student;

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
SELECT 
    COUNT(CASE WHEN gender = 'Nam' THEN 1 END) AS male_students,
    COUNT(CASE WHEN gender = 'Nữ' THEN 1 END) AS female_students
FROM student;

-- 4. Tính tổng số sinh viên từng khoa
SELECT faculty_id, COUNT(*)
FROM student
GROUP BY faculty_id;

-- 5. Tính tổng số sinh viên của từng môn học
SELECT subject_id, COUNT(*)
FROM exam_management
GROUP BY subject_id;

-- 6. Tính số lượng môn học mà sinh viên đã học
SELECT student_id, COUNT(*)
FROM exam_management
GROUP BY student_id;

-- 7. Tổng số học bổng của mỗi khoa	
SELECT s.faculty_id, SUM(s.scholarship) AS total_scholarship
FROM student s
GROUP BY s.faculty_id;

-- 8. Cho biết học bổng cao nhất của mỗi khoa
SELECT faculty_id, MAX(scholarship) AS max_scholarship
FROM student
GROUP BY faculty_id;

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
SELECT faculty_id, 
       COUNT(CASE WHEN gender = 'Nam' THEN 1 END) AS male_students,
       COUNT(CASE WHEN gender = 'Nữ' THEN 1 END) AS female_students
FROM student
GROUP BY faculty_id;

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, birthday) / 12) AS age_group, COUNT(*)
FROM student
GROUP BY TRUNC(MONTHS_BETWEEN(SYSDATE, birthday) / 12);

-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
SELECT hometown
FROM student
GROUP BY hometown
HAVING COUNT(*) >= 2;

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
SELECT student_id
FROM exam_management
GROUP BY student_id
HAVING COUNT(*) >= 2;

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 
SELECT student_id
FROM exam_management
GROUP BY student_id
HAVING COUNT(*) >= 2;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
SELECT student_id
FROM exam_management
WHERE number_of_exam_taking = 1 AND mark < 4
GROUP BY student_id
HAVING COUNT(*) >= 2;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
SELECT faculty_id
FROM student
WHERE gender = 'Nam'
GROUP BY faculty_id
HAVING COUNT(*) > 2;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
SELECT faculty_id
FROM student
WHERE scholarship BETWEEN 200000 AND 300000
GROUP BY faculty_id
HAVING COUNT(*) = 2;

-- 17. Cho biết sinh viên nào có học bổng cao nhất
SELECT student_id
FROM student
WHERE scholarship = (SELECT MAX(scholarship) FROM student);


-------------------------------------------------------------------
/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
SELECT *
FROM student
WHERE hometown = 'Hà Nội' AND TO_CHAR(birthday, 'MM') = '02';

-- 2. Sinh viên có tuổi lớn hơn 20
SELECT *
FROM student
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, birthday) / 12) > 20;

-- 3. Sinh viên sinh vào mùa xuân năm 1990
SELECT *
FROM student
WHERE EXTRACT(YEAR FROM birthday) = 1990 AND EXTRACT(MONTH FROM birthday) BETWEEN 1 AND 3;



-------------------------------------------------------------------


/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
SELECT *
FROM student
WHERE faculty_id IN (SELECT id FROM faculty WHERE name IN ('Anh - Văn', 'Vật lý'));

-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
SELECT *
FROM student
WHERE gender = 'Nam' AND faculty_id IN (SELECT id FROM faculty WHERE name IN ('Anh - Văn', 'Tin học'));

-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
SELECT student_id
FROM exam_management
WHERE subject_id = (SELECT id FROM subject WHERE name = 'Cơ sở dữ liệu')
ORDER BY mark DESC
FETCH FIRST ROW ONLY;

-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
SELECT *
FROM student
WHERE faculty_id = (SELECT id FROM faculty WHERE name = 'Anh - Văn')
ORDER BY birthday DESC
FETCH FIRST ROW ONLY;

-- 5. Cho biết khoa nào có đông sinh viên nhất
SELECT faculty_id, COUNT(*) AS student_count
FROM student
GROUP BY faculty_id
ORDER BY COUNT(*) DESC
FETCH FIRST ROW ONLY;

-- 6. Cho biết khoa nào có đông nữ nhất
SELECT faculty_id, COUNT(*) AS female_count
FROM student
WHERE gender = 'Nữ'
GROUP BY faculty_id
ORDER BY COUNT(*) DESC
FETCH FIRST ROW ONLY;

-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
SELECT subject_id, MAX(mark) AS max_mark
FROM exam_management
GROUP BY subject_id;

-- 8. Cho biết những khoa không có sinh viên học
SELECT id
FROM faculty
WHERE id NOT IN (SELECT DISTINCT faculty_id FROM student);

-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
SELECT *
FROM student
WHERE id NOT IN (SELECT student_id FROM exam_management WHERE subject_id = 1);

-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
SELECT *
FROM student
WHERE id NOT IN (SELECT student_id FROM exam_management WHERE number_of_exam_taking = 1);
