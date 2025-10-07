<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Timetable;
use App\Models\Classes;
use App\Models\Semester;
use App\Models\School;
use Faker\Factory as Faker;

class TimetableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = Faker::create();

        // ✅ Safely get existing IDs
        $classIds = Classes::pluck('id')->toArray();
        $semesterIds = Semester::pluck('id')->toArray();
        $schoolIds = School::pluck('id')->toArray();

        // ✅ Prevent running if dependencies are missing
        if (empty($classIds) || empty($semesterIds) || empty($schoolIds)) {
            $this->command->warn('⚠️ Skipping TimetableSeeder — missing related data (classes, semesters, or schools).');
            return;
        }

        // ✅ Create one fixed record
        Timetable::firstOrCreate([
            'id' => 1,
        ], [
            'name'        => 'Timetable 1',
            'description' => 'Timetable 1 description',
            'class_id'    => $faker->randomElement($classIds),
            'semester_id' => $faker->randomElement($semesterIds),
            'school_id'   => $faker->randomElement($schoolIds),
        ]);

        // ✅ Create 10 more random timetables
        foreach (range(1, 10) as $i) {
            Timetable::create([
                'name'        => $faker->sentence(2),
                'description' => $faker->sentence(6),
                'class_id'    => $faker->randomElement($classIds),
                'semester_id' => $faker->randomElement($semesterIds),
                'school_id'   => $faker->randomElement($schoolIds),
            ]);
        }

        $this->command->info('✅ TimetableSeeder completed successfully!');
    }
}
