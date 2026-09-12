document.addEventListener('DOMContentLoaded', () => {
  const origin = window.location.origin;
  const hostname = window.location.hostname;
  const downloadUrl = `${origin}/synapmusic/download`;

  // 1. Configurar enlaces de descarga directa
  const downloadBtns = document.querySelectorAll('.js-download-link');
  downloadBtns.forEach(btn => {
    btn.setAttribute('href', downloadUrl);
  });

  // 2. Generar Código QR Dinámico (si existe el contenedor)
  const qrContainer = document.getElementById('qrcode');
  if (qrContainer && typeof QRCode !== 'undefined') {
    try {
      new QRCode(qrContainer, {
        text: downloadUrl,
        width: 180,
        height: 180,
        colorDark: "#0c0f17",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.M
      });
    } catch (e) {
      console.warn("No se pudo renderizar el QR:", e);
    }
  }

  // 3. Autocompletar la dirección de conexión para Jellyfin / Servidor
  const serverInput = document.getElementById('server-address-input');
  if (serverInput) {
    // Sugerir la dirección de Jellyfin (puerto 8096)
    serverInput.value = `http://${hostname}:8096`;
  }

  // 4. Copiar al portapapeles con feedback visual
  const copyBtns = document.querySelectorAll('.js-btn-copy');
  copyBtns.forEach(btn => {
    btn.addEventListener('click', async () => {
      const targetId = btn.getAttribute('data-target');
      const targetInput = document.getElementById(targetId);
      if (!targetInput) return;

      try {
        await navigator.clipboard.writeText(targetInput.value);
        const originalText = btn.textContent;
        btn.textContent = '✓ ¡Copiado!';
        btn.classList.add('copied');

        setTimeout(() => {
          btn.textContent = originalText;
          btn.classList.remove('copied');
        }, 2200);
      } catch (err) {
        // Fallback clásico
        targetInput.select();
        document.execCommand('copy');
        btn.textContent = '✓ ¡Copiado!';
        btn.classList.add('copied');
        setTimeout(() => {
          btn.textContent = 'Copiar';
          btn.classList.remove('copied');
        }, 2200);
      }
    });
  });

  // 5. Detección de dispositivo móvil
  const isMobile = /Android|iPhone|iPad|iPod|Windows Phone/i.test(navigator.userAgent);
  const qrCard = document.querySelector('.qr-card');
  if (isMobile && qrCard) {
    // Si ya está en el móvil, poner el QR en un bloque secundario o más compacto
    const qrCaption = qrCard.querySelector('.qr-caption');
    if (qrCaption) {
      qrCaption.textContent = 'O comparte este código con otro dispositivo';
    }
  }
});
