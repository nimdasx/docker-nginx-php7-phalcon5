# Instruksi & Konteks Proyek

## 1. Gambaran Umum Proyek
- Repositori ini membangun Docker image: **`nimdasx/nginx-php7-phalcon5`** (juga di-mirror ke `ghcr.io/nimdasx/nginx-php7-phalcon5` dan registry harbor internal `harbor.sofy.web.id/x/nginx-php7-phalcon5`).
- Image ini digunakan untuk lingkungan produksi aplikasi web berbasis framework Phalcon 5.
- Arsitektur: **Nginx + PHP-FPM 7.4.33 + Phalcon 5.4.0 + IonCube Loader** di atas Alpine Linux 3.16 (`webdevops/php-nginx:7.4-alpine`).

---

## 2. Konteks Tugas: Backport Keamanan RCE PHP (CVE-2026-109618 & CVE-2026-109619)
- **Tujuan Utama:** Menutup kerentanan kritis Remote Code Execution (RCE) tanpa autentikasi (*PHP2Shell*) pada PHP 7.4 legacy tanpa mengubah kode sumber aplikasi.
- **Rujukan Resmi:** PHP Security Advisory 21 & 23 Oktober 2026 ([php.net Archive 2026](https://www.php.net/archive/2026.php#2026-10-21-5)).
- **Branch Patch Resmi:** [`PHP-7.4-CVE-2026-109618-109619`](https://github.com/php/php-src/tree/PHP-7.4-CVE-2026-109618-109619).
- **File Patch Tersedia:** Berkas patch lokal sudah disimpan di repositori ini: `CVE-2026-109618-109619.patch`.
- **Kompatibilitas ABI:** Patch ini 100% ABI-compatible dengan PHP 7.4.33 (API `20190902`), sehingga seluruh ekstensi (`phalcon-5.4.0`, `ioncube_loader`, `sqlsrv`, `pdo_sqlsrv`, `pdo_mysql`, dll.) tetap berfungsi normal.

---

## 3. Catatan Teknis Lingkungan Build
1. **Alpine Linux & GNU libiconv:**
   - Kompilasi PHP pada Alpine (musl libc) membutuhkan `gnu-libiconv-dev`.
   - Header bawaan musl di `/usr/include/iconv.h` perlu digantikan dengan symlink dari `/usr/include/gnu-libiconv/*.h` ke `/usr/include/` agar `./configure` mendeteksi iconv dengan benar.
2. **Rebuild Flow PHP-FPM:**
   - Ekstrak source bawaan: `docker-php-source extract` (lokasi di `/usr/src/php`).
   - Terapkan patch: `patch -p1 < /tmp/CVE-2026-109618-109619.patch`.
   - Jalankan `./configure` dengan opsi bawaan `webdevops/php-nginx:7.4-alpine` (`--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data`).
   - Jalankan `make -j "$(nproc)" && make install`.
   - Bersihkan source (`docker-php-source delete`) dan hapus virtual build dependencies (`apk del --no-network .build-deps`).
3. **Pemasangan Ekstensi:** Ekstensi tetap di-install via `install-php-extensions`:
   `sqlsrv pdo_sqlsrv phalcon-5.4.0`

---

## 4. Batasan & Aturan Kerja
- Hanya lakukan commit dan push ke Git jika ada instruksi eksplisit dari maintainer.
- Jangan melakukan `docker push` ke Docker Hub, GHCR, atau Harbor kecuali setelah disetujui dan diperintahkan oleh maintainer.
- Pastikan setiap perubahan tetap mempertahankan kompatibilitas penuh dengan framework Phalcon 5.4.0, Node.js/NPM, dan Nginx vhost config.
