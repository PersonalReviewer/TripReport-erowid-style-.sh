#!/bin/bash

# Clear screen for a clean UI
clear
echo "=========================================="
echo "    ADVANCED EXPERIENCE LOG GENERATOR     "
echo "=========================================="

# 1. Gather Baseline Metadata
CURRENT_DATE=$(date +%Y-%m-%d)
START_TIME=$(date +%H:%M)

read -p "📝 Substance Name: " SUBSTANCE
read -p "⚖️  Dosage (e.g., 20mg, 2g, 150ug): " DOSAGE
read -p "👄 Route of Administration (e.g., Oral, Vaped): " ROA
read -p "🧠 Set (Mindset before ingestion): " SET
read -p "🏠 Setting (Current environment): " SETTING

# Format filename: YYYY-MM-DD_substance.md
FILE_SUBSTANCE=$(echo "$SUBSTANCE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
FILENAME="${CURRENT_DATE}_${FILE_SUBSTANCE}.md"

# 2. Generate Initial File Structure
cat << EOF > "$FILENAME"
# ${SUBSTANCE} Experience Report: [Insert Title]

## Meta Information
* **Substance(s) Used:** ${SUBSTANCE}
* **Dosage:** ${DOSAGE}
* **Route of Administration:** ${ROA}
* **Date / Start Time:** ${CURRENT_DATE} @ ${START_TIME}
* **Set (Mindset):** ${SET}
* **Setting (Environment):** ${SETTING}
* **Prior Tolerance:** [None / Baseline / Recent exposure]

---

## Timeline & Log
* **T+00:00** (${START_TIME}) - [Ingestion] Dose administered.
EOF

echo "------------------------------------------"
echo "✅ Baseline template created: $FILENAME"
echo "------------------------------------------"

# 3. Interactive Live Timeline Option
read -p "⏱️  Do you want to start Live Timeline Mode? (y/n): " LIVE_MODE

if [[ "$LIVE_MODE" =~ ^[Yy]$ ]]; then
    # Record start time in seconds for delta calculations
    START_EPOCH=$(date +%s)
    
    echo ""
    echo "🚀 Live Logging Active! Script is tracking time relative to T+00:00."
    echo "👉 Type your entry and press Enter to append it to your report."
    echo "👉 Type 'exit' or 'quit' when your experience is finished."
    echo "------------------------------------------------------------------"

    while true; do
        read -p "✨ [New Entry]: " USER_ENTRY
        
        # Check if user wants to exit
        if [[ "${USER_ENTRY,,}" == "exit" || "${USER_ENTRY,,}" == "quit" ]]; then
            echo "Stopping live logger..."
            break
        fi
        
        # Skip empty entries
        if [[ -z "$USER_ENTRY" ]]; then
            continue
        fi

        # Calculate time elapsed since start
        NOW_EPOCH=$(date +%s)
        ELAPSED_SECS=$((NOW_EPOCH - START_EPOCH))
        
        HOURS=$((ELAPSED_SECS / 3600))
        MINUTES=$(((ELAPSED_SECS % 3600) / 60))
        
        # Format strings nicely (e.g., T+01:23)
        TIMESTAMP=$(printf "T+%02d:%02d" $HOURS $MINUTES)
        CLOCK_TIME=$(date +%H:%M)

        # Append new entry directly to the file under the Timeline section
        echo "* **${TIMESTAMP}** (${CLOCK_TIME}) - ${USER_ENTRY}" >> "$FILENAME"
        echo "   💾 Appended: [${TIMESTAMP}] ${USER_ENTRY}"
    done
fi

# 4. Append Post-Experience Sections
cat << EOF >> "$FILENAME"

---

## Subjective Effects Index
* **Visual Effects:** 
* **Physical Effects (Body load, heart rate, stimulation):** 
* **Cognitive Effects (Headspace, anxiety, euphoria):** 

## Conclusion & Takeaways
* **Main Lesson / Summary:** 
* **Rating (1-10):** 
* **Side Effects / Hangover:** 
EOF

echo "------------------------------------------"
echo "🏁 Final Report Saved to: $FILENAME"
echo "You can open this file anytime to review or edit."
echo "=========================================="
