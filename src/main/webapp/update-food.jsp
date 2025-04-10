<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Update Food Items</title>
  <style>
    body {
      font-family: Arial, sans-serif;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px;
      border: 1px solid #ccc;
    }
    th {
      background-color: #f4f4f4;
    }
    input, select {
      width: 100%;
      padding: 6px;
      box-sizing: border-box;
    }
    .popup {
      display: none;
      position: fixed;
      top: 50%;
      left: 50%;
      width: 300px;
      transform: translate(-50%, -50%);
      background: white;
      border: 2px solid green;
      padding: 20px;
      text-align: center;
      z-index: 100;
    }
    .popup.show {
      display: block;
    }
    .save-button {
      padding: 6px 12px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .save-button:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>

<h2>Update Food Items</h2>
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Category</th>
      <th>Rating</th>
      <th>Price</th>
      <th>Image URL</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody id="foodItemsBody"></tbody>
</table>

<div class="popup" id="popup">
  <h3>Item Updated!</h3>
  <p>The item was successfully updated in Firebase.</p>
  <button onclick="closePopup()">OK</button>
</div>

<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
  import { getDatabase, ref, get, set } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-database.js";

  const firebaseConfig = {
    apiKey: "AIzaSyCU8-WUpNCecR-ZWjiySfaelZVke6qC08U",
    authDomain: "grabit-mpstme.firebaseapp.com",
    databaseURL: "https://grabit-mpstme-default-rtdb.firebaseio.com",
    projectId: "grabit-mpstme",
    storageBucket: "grabit-mpstme.appspot.com",
    messagingSenderId: "180238227469",
    appId: "1:180238227469:web:11b04a0b5404c3e345ca9e",
    measurementId: "G-7B4QW1XZZN"
  };

  const app = initializeApp(firebaseConfig);
  const database = getDatabase(app);

  const tableBody = document.getElementById("foodItemsBody");

  const foodItemsRef = ref(database, "FoodItems");
  get(foodItemsRef).then((snapshot) => {
    if (snapshot.exists()) {
      const foodItems = snapshot.val();
      if (Object.keys(foodItems).length === 0) {
        tableBody.innerHTML = "<tr><td colspan='6'>No data found</td></tr>";
      } else {
        Object.entries(foodItems).forEach(([id, data]) => {
          const row = document.createElement("tr");

          const nameInput = createInput(data.name);
          const categorySelect = createSelect(data.category);
          const ratingInput = createInput(data.rating, true);
          const priceInput = createInput(data.price);
          const imageInput = createInput(data.imageUrl);

          const saveBtn = document.createElement("button");
          saveBtn.className = "save-button";
          saveBtn.textContent = "Save";

          saveBtn.onclick = () => {
            const updatedData = {
              name: nameInput.value,
              category: categorySelect.value,
              rating: parseFloat(ratingInput.value) || 0,
              price: parseFloat(priceInput.value) || 0,
              imageUrl: imageInput.value
            };

            // Update only the specific entry in the database
            const itemRef = ref(database, `FoodItems/${id}`);
            set(itemRef, updatedData)
              .then(() => showPopup())
              .catch((error) => alert("Update failed: " + error.message));
          };

          [nameInput, categorySelect, ratingInput, priceInput, imageInput].forEach(el => {
            const td = document.createElement("td");
            td.appendChild(el);
            row.appendChild(td);
          });

          const actionTd = document.createElement("td");
          actionTd.appendChild(saveBtn);
          row.appendChild(actionTd);

          tableBody.appendChild(row);
        });
      }
    } else {
      tableBody.innerHTML = "<tr><td colspan='6'>No data found</td></tr>";
    }
  });

  function createInput(value, disabled = false) {
    const input = document.createElement("input");
    input.value = value || "";
    if (disabled) input.disabled = true;
    return input;
  }

  function createSelect(selected) {
    const select = document.createElement("select");
    ["Breakfast", "Lunch", "Snacks", "Dinner", "Dessert"].forEach(optionVal => {
      const opt = document.createElement("option");
      opt.value = optionVal;
      opt.textContent = optionVal;
      if (selected === optionVal) opt.selected = true;
      select.appendChild(opt);
    });
    return select;
  }

  function showPopup() {
    document.getElementById("popup").classList.add("show");
  }

  function closePopup() {
    document.getElementById("popup").classList.remove("show");
  }
</script>

</body>
</html>
