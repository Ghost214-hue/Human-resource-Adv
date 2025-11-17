<?php
require_once 'vendor/autoload.php';

echo "<h2>Testing Library Installation</h2>";

// Test TCPDF
if (class_exists('TCPDF')) {
    echo "✅ TCPDF is installed correctly<br>";
    try {
        $pdf = new TCPDF();
        echo "✅ TCPDF can be instantiated<br>";
    } catch (Exception $e) {
        echo "❌ TCPDF instantiation failed: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ TCPDF is NOT installed<br>";
}

// Test PhpSpreadsheet
if (class_exists('PhpOffice\PhpSpreadsheet\Spreadsheet')) {
    echo "✅ PhpSpreadsheet is installed correctly<br>";
    try {
        $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
        echo "✅ PhpSpreadsheet can be instantiated<br>";
    } catch (Exception $e) {
        echo "❌ PhpSpreadsheet instantiation failed: " . $e->getMessage() . "<br>";
    }
} else {
    echo "❌ PhpSpreadsheet is NOT installed<br>";
}

// Check vendor directory
echo "<h3>Vendor Directory Check:</h3>";
if (is_dir('vendor')) {
    echo "✅ Vendor directory exists<br>";
    
    if (is_dir('vendor/tecnickcom/tcpdf')) {
        echo "✅ TCPDF directory exists<br>";
    } else {
        echo "❌ TCPDF directory NOT found<br>";
    }
    
    if (is_dir('vendor/phpoffice/phpspreadsheet')) {
        echo "✅ PhpSpreadsheet directory exists<br>";
    } else {
        echo "❌ PhpSpreadsheet directory NOT found<br>";
    }
} else {
    echo "❌ Vendor directory does NOT exist<br>";
}
?>