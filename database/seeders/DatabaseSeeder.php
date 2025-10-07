<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database. TimetableSeeder
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            // 1️⃣ Foundational data — must exist first
            SchoolSeeder::class,
            RolesAndPermissionsSeeder::class,
            SchoolSettingsSeeder::class,

            // 2️⃣ Academic structure (schools, years, semesters, classes)
            AcademicYearSeeder::class,
            SemesterSeeder::class,
            ClassesSeeder::class,

            // 3️⃣ Users (teachers, students, admins)
            UserSeeder::class,

            // 4️⃣ Subjects depend on classes and teachers
            SubjectSeeder::class,

            // 5️⃣ Timetables depend on class, semester, and school
            TimetableSeeder::class,

            // 6️⃣ Slots depend on timetable
            TimeTableTimeSlotSeeder::class,

            // 7️⃣ Weekdays can come any time before timetable usage or after timetables
            WeekDaySeeder::class,

            // 8️⃣ Exams depend on academic + classes
            ExamSeeder::class,
            ExamRecordSeeder::class,

            // 9️⃣ Permissions at the end
            PermissionSeeder::class,
        ]);



    }
}
