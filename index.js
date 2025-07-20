import express from 'express';
import puppeteer from 'puppeteer';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json({ limit: '5mb' }));

app.post('/generate', async (req, res) => {
  const { html } = req.body;
  if (!html) return res.status(400).send('No HTML provided');

  try {
    const browser = await puppeteer.launch({
      headless: 'new',
      args: ['--no-sandbox']
    });
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle0' });

    const pdfBuffer = await page.pdf({
      format: 'A4',
      printBackground: true,
      margin: {
        top: '0mm',
        bottom: '0mm',
        left: '0mm',
        right: '0mm'
      }
    });

    await browser.close();

    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline; filename="document.pdf"',
    });

    res.send(pdfBuffer);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error generating PDF');
  }
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`PDF server listening on port ${port}`);
});
