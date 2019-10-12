module D exposing (Question, da, db, dc, dd)


type alias Question =
    { q : String
    , a : Bool
    , e : String
    }


da : List Question
da =
    [ { q = "The pulmonary arteries contain oxygenated blood."
      , a = False
      , e = "The pulmonary arteries, unlike most other arteries, contain deoxygenated blood. They take deoxygenated blood from the right heart to the lungs so they can be replenished with oxygen. "
      }
    , { q = "The reaction in the tuberculin skin test is classified as a Type IV hypersensitivity reaction."
      , a = True
      , e = "Type IV hypersensitivity (or delayed-type hypersensitivity) is mediated by T-cells, which attempt to contain a re-exposed antigen. The tuberculin skin test is the prototypical example of Type IV hypersensitivity, and used to test previous exposure to the tuberculosis. "
      }
    , { q = "Corticosteroids work by reducing the action of phospholipase A2. "
      , a = True
      , e = "By inhibiting phospholipase A2 (which converts phospholipids into arachidonic acid), corticosteroids reduce the production of prostaglandins (many of which are inflammatory mediators). "
      }
    , { q = "Mitral stenosis results in a systolic murmur."
      , a = False
      , e = "Mitral stenosis is accentuated during diastole when the ventricles fill with blood (i.e. when blood passes through the stenosed valve), so results in a diastolic murmur, not a systolic murmur."
      }
    , { q = "The plateau of the ventricular action potential in cardiac myocytes is maintained by calcium ion influx."
      , a = True
      , e = "The plateau phase of the ventricular action potential (phase 2) is maintained by inward movement of positive calcium ions through slow, long-lasting (L-type) calcium channels. "
      }
    , { q = "Mobitz second degree type I heart block refers to intermittently dropped QRS complexes without PR prolongation."
      , a = False
      , e = "Mobitz second degree type I (Wenckebach) heart block refers to gradually increasing PR intervals, until a QRS is dropped. It is Mobitz second degree type II heart block which refers to intermittently dropped QRS complexes without prolonged PR intervals."
      }
    , { q = "Cardiac output is the product of heart rate and stroke volume."
      , a = True
      , e = "Cardiac output (i.e. the volume of blood pumped per unit time) is the multiplication product of stroke volume (volume per beat) and heart rate (beats per unit time). "
      }
    , { q = "In a non-overloaded heart, an increase in venous return will decrease cardiac output."
      , a = False
      , e = "According to the Frank-Starling Law, an increase in venous return will cause a corresponding increase in cardiac output, not a decrease (as long as the heart is not overloaded).This occurs because an increase in venous return distends the ventricles with more blood, and thereby increases their force of contraction, leading them to pump out more blood."
      }
    , { q = "A reduction in blood pressure causes a decrease in baroreceptor firing in the carotic sinus."
      , a = True
      , e = "A decrease in blood pressure causes a decrease in baroreceptor firing in the carotid sinus (e.g. when you suddenly stand up). Normally baroreceptor firing puts a clamp on sympathetic activity; a reduction in firing disinhibits (and therefore increases) sympathetic outflow in order to increase blood pressure. A reduction in baroreceptor firing also reduces vagal tone, allowing the heart to pump faster and further increase and maintain blood pressure."
      }
    , { q = "Heart dominance is established by determining which coronary artery supplies the left anterior descending artery. "
      , a = False
      , e = "Heart dominance is established by which coronary artery supplies the posterior descending artery (PDA) (which supplies the posterior portion of the intraventricular septum), not the left anterior descending artery (LAD). Most hearts are right dominant. "
      }
    , { q = "An increase in intracranial pressure beyond mean arterial pressure results in a drop in blood pressure."
      , a = False
      , e = "Somewhat paradoxically, an increase in ICP beyond MAP causes an increase in blood pressure. The response to an increase in ICP beyond the MAP is known as Cushing’s reflex. An increase in ICP beyond MAP collapses cerebral arteries and results in sympathetic stimulation, increasing blood pressure. The response is also characterised by bradycardia (due to the baroreceptor response to increased blood pressure) and irregular breathing (due to pressure on breathing centres in the brainstem). If you see this response, death is imminent and you must act immediately. "
      }
    , { q = "Chylomicrons transfer endogenous lipid produced by the liver to tissues."
      , a = False
      , e = "Chylomicrons transfer exogenous lipids (absorbed in the intestine) to the liver.  It is VLDL particles which transfer endogenous lipids produced by the liver to tissues."
      }
    , { q = "Statins inhibit HMG-CoA reductase."
      , a = True
      , e = "HMG-CoA reductase is a the rate-controlling enzyme involved in the biosynthesis of endogenous cholesterol. Inhibiting HMG-CoA reductase reduces the production of endogenous cholesterol.  Hence why HMG-CoA reductase inhibitors (e.g. statins) are used in the treatment of hyperlipidaemia."
      }
    , { q = "ECG leads II, III and aVF correspond to a view of the lateral heart."
      , a = False
      , e = "ECG leads II, III and aVF correspond to a view of the inferior heart. A view of the lateral heart is provided by leads I, V5 and V6."
      }
    , { q = "Positive predictive value refers to the proportion of people who test positive for a disease, out of people who are truly positive for a disease."
      , a = False
      , e = "PPV refers to the proportion of people who are truly positive for a disease, out of people who test positive. Sensitivity is the proportion of people who test positive, out of people who are truly positive for a disease. This distinction is important; for example, asking someone seriously if they have committed murder is likely to have a high PPV but a low sensitivity."
      }
    , { q = "Propranolol is a non-selective beta blocker."
      , a = True
      , e = "Beta adrenergic receptors come in three main types, each with different functions; some beta blockers target specific receptors, such as cardioselective beta blockers (e.g. metoprolol) which target beta 1 receptors specifically in order to exert cardio-selective effects. Propranolol, however, is a non-selective beta-blocker, and used in general to reduce sympathetic effects such as in thyrotoxicosis or anxiety."
      }
    , { q = "Digoxin inhibits Na+/K+ ATPase pump."
      , a = True
      , e = "Digoxin inhibits the Na+/K+ ATPase pump, which increases intracellular sodium and indirectly increases intracellular calcium, which thereby increases the cardiomyocyte contractility (making digoxin a positive inotrope) and prolongs the cardiac action potential. Digoxin also increases vagal tone to exert a negative chronotropic effect (slowing the heart rate). "
      }
    , { q = "NSAIDs exert an anti-inflammatory effect by inhibiting COX enzymes."
      , a = True
      , e = "NSAIDs inhibit COX to exert an anti-inflammatory effect. COX converts arachidonic acid to prostaglandins, many of which are pro-inflammatory."
      }
    , { q = "Naloxone is an opioid antagonist used to treat opioid overdose."
      , a = True
      , e = "Naloxone competitively antagonises opioids receptors, and is therefore useful to combat opioid overdose (which may result in fatal respiratory depression)."
      }
    , { q = "Colchicine is a xanthine oxidase inhibitor useful for long-term prevention of gout."
      , a = False
      , e = "Colchicine reduces the motility and activity of neutrophils, and is generally used as treatment for acute flareups of gout. Allopurinol is a xanthine oxidase inhibitor (thereby reducing the production of uric acid) used in the long-term preventive treatment of gout (and should not be used in acute flareups). "
      }
    , { q = "Retroviruses like HIV are composed of viral RNA, which is transcribed to DNA and integrated in the host genome."
      , a = True
      , e = "Retroviruses use reverse transcriptase to convert viral RNA to DNA (hence “reverse”, as transcription refers to the conversion of DNA to RNA), which is then integrated using integrase enzymes into the host genome. Once integrated, the host produces viral proteins from its own modified genome. "
      }
    , { q = "Janeway lesions and Osler’s nodes are suggestive of infective endocarditis."
      , a = True
      , e = "In infective endocarditis, septic emboli may be “flicked off” from bacterial vegetations on heart valves. These septic emboli can travel peripherally (bacteria and all) to small vessels, deposit and form microabscesses, which when found on the palms or fingers are termed Janeway lesions and Osler’s nodes respectively."
      }
    , { q = "Karyolysis (dissolution of chromatin) is a feature of apoptosis."
      , a = False
      , e = "Karyolysis is a feature of necrosis, not apoptosis. In apoptosis, cellular material (including nuclear material) is usually fragmented off and contained in apoptotic bodies.  In necrosis, cellular material tends to be released in a more haphazard matter, cellular swelling occurs and the cell may rupture out its messy contents."
      }
    , { q = "The foramen ovale is a right to left shunt in the developing fetus."
      , a = True
      , e = "The foramen ovale shunts blood from the right atrium to the left atrium, allowing oxygenated blood from the placenta to bypass the (non-functional) lungs and directly enter the systemic circulation. After birth, the foramen ovale closes and eventually forms a depression called the fossa ovalis. "
      }
    , { q = "Sensation to the webbed space between the first and second toe is supplied by the superficial fibular nerve."
      , a = False
      , e = "Sensation to the webbed space between the first and second toe is (specially) provided by the deep fibular/peroneal nerve, not the superficial fibular nerve. The superficial fibular nerve supplies most of the sensation of the remaining part of the dorsum of the foot."
      }
    , { q = "The tendon of the tibialis posterior muscle passes behind the medial malleolus."
      , a = True
      , e = "The tibialis posterior tendon (along with the posterior tibial pulse!) passes behind the medial malleolus, with the flexor digitorum longus and flexor hallicus longus (often remembered with the mnemonic ‘Tom, Dick and Harry.’)"
      }
    , { q = "Risk factors predisposing to an extremely rare disease are best studied with a cohort study."
      , a = False
      , e = "Extremely rare outcomes are best studied with case-control studies (where you definitively get both cases and controls); you may not get a single outcome if you do a cohort study! Cohort studies are, in contrast, best suited for extremely rare exposures (e.g. war). "
      }
    , { q = "Lignocaine exerts a local anaesthetic effect by blocking sodium channels. "
      , a = True
      , e = "By blocking sodium channels, lignocaine can reduce the probability of an action potential being generated (thereby reducing the transmission and/or generation of pain signals)."
      }
    , { q = "An increase in parasympathetic outflow causes pupillary dilation (mydriasis). "
      , a = False
      , e = "Parasympathetic outflow causes pupillary constriction (miosis), not dilation. This is the reasoning for why an anti-muscarinic (which reduces the drive for pupillary constriction) is often used prior to funduscopy (as a dilated pupil provides a much larger window with which to view the back of the eye)."
      }
    , { q = "Both parasympathetic and sympathetic preganglionic nerve fibres are cholinergic. "
      , a = True
      , e = "The primary neurotransmitter of preganglionic neurons in both arms of the autonomic nervous system is acetylcholine. It is the postganglionic neurons which differ between the parasympathetic and sympathetic systems (parasympathetic postganglionic neurons typically use ACh, whereas sympathetic postganglionic neurons typically use noradrenaline). "
      }
    , { q = "Opponens pollicis is supplied by the ulnar nerve."
      , a = False
      , e = "While most of the intrinsic hand muscles are supplied by the ulnar nerve, opponens pollicis is one of the LOAF muscles supplied by the median nerve. In fact, opponens pollicis is supplied by the recurrent branch of the median nerve sometimes called the “million dollar nerve” as it may be accidentally damaged during carpal tunnel surgery and cause a loss of thumb function (and a million dollar lawsuit). "
      }
    , { q = "Anaerobic respiration involves the conversion of pyruvate to lactate."
      , a = True
      , e = "When oxygen is limited in skeletal muscle, pyruvate is fed into the Cori cycle (rather than the Krebs cycle) and converted to lactate while replenishing NAD+. Lactate is then transported back to the liver where it is converted back into pyruvate and glucose at a net ATP cost (effectively offloading the metabolic burden from skeletal muscle to the liver). "
      }
    , { q = "A high therapeutic index indicates there is only a small difference between the toxic and effective dose of a drug."
      , a = False
      , e = "The therapeutic index is the ratio between the toxic dose and the effective dose of a drug. A high therapeutic index therefore means there is a larger difference between the toxic and effective dose (and therefore a higher therapeutic index is “safer” and more desirable). "
      }
    , { q = "The iliopsoas muscle attaches to the lesser trochanter of the femur."
      , a = True
      , e = "The iliopsoas, the strongest hip flexor, attaches to the lesser trochanter of the femur from the iliac fossa and lumbar spine. "
      }
    , { q = "Erb’s palsy refers to damage to the lower portion of the brachial plexus. "
      , a = False
      , e = "Erb’s palsy refers to damage of the upper portion of the brachial plexus, often due to birth trauma. This typically leads to a “water’s tip” deformity. Don’t get confused with Klumpke’s palsy, which refers to damage of the lower portion of the brachial plexus and often damages roots supplying the wrist flexors and intrinsic hand muscles (thereby resulting in a “claw hand” deformity and Horner’s syndrome)."
      }
    , { q = "During skeletal muscle contraction, the A-band does not shorten."
      , a = True
      , e = "The A-band is the full length of the myosin/thick filament. During skeletal muscle contraction, myosin heads conduct a “power stroke” to pull the actin filaments closer together; however, the myosin/thick filament doesn’t itself contract (and therefore the A-band does not change). The H-band (space between actin/thin filaments) and the I-band (actin filaments not superimposing myosin), however, do both shorten."
      }
    , { q = "In the spinal cord, fibres transmitting pain and temperature sensation travel in the dorsal column-medial lemniscus pathway."
      , a = False
      , e = "Pain and temperature sensation is conveyed through the spinothalamic tract in the spinal cord.  The dorsal column-medial lemniscus pathway conveys proprioception and vibration sensation. "
      }
    , { q = "Dysdiadochokinesia and dysmetria may be suggestive of cerebellar dysfunction."
      , a = True
      , e = "Dysdiadochokinesia (the fast hand-flipping test) and dysmetria (overshoot or undershoot on tapping your finger) are often due to lack of motor coordination, which may reflect cerebellar dysfunction (though a proprioceptive defect may present similarly)."
      }
    , { q = "CD8+ T cells interact with class II MHC molecules and release cytokines to help mediate other immune cells."
      , a = False
      , e = "CD8+ T-cells interact with class I MHC molecules, not class II, and have a role in directly eliminating cells they interact with (hence the name “cytotoxic T-cells”). "
      }
    , { q = "Haemophilia A cannot be passed down from father to son."
      , a = True
      , e = "Haemophilia is an X-linked genetic disorder. As all men must inherit their Y chromosome from their father, they cannot inherit an affected father’s X chromosome. X-linked disorders can only be transmitted to sons via their mother. "
      }
    ]


db : List Question
db =
    [ { q = "Surfactant in the lungs is produced by Clara cells."
      , a = False
      , e = "Surfactant in the lungs is produced by Type II pneumocytes lining the alveoli, not Clara cells. Clara cells (aka club cells) appear to have an immunomodulatory, protective function in the lungs."
      }
    , { q = "Each bronchopulmonary segment in the lung has its own vascular supply. "
      , a = True
      , e = "Bronchopulmonary segments are discrete units separated by connective tissue. This feature means they can be safely surgically resected without disturbing other segments. "
      }
    , { q = "The diaphragm is innervated by the vagus nerve."
      , a = False
      , e = "The diaphragm is innervated by the phrenic nerve (C3, C4, C5), not the vagus nerve (the word “phrenic” has Greek roots, meaning diaphragm!)"
      }
    , { q = "Emphysema results in increased lung compliance."
      , a = True
      , e = "Emphysema damages the elastic tissue in the lungs, so the lungs are much more prone to expansion with even small transpulmonary pressures (hence the typical “barrel chest” and overinflated lungs seen)."
      }
    , { q = "There is an increased FEV1/FVC ratio in asthma."
      , a = False
      , e = "In asthma, the FEV1/FVC ratio is decreased, not increased. The FEV1/FVC ratio reflects the “speed” at which people can initially exhale – if its high, they can exhale fast, whereas if its low, they can’t exhale very fast at all (most likely due to airway obstrution, as in asthma). "
      }
    , { q = "The normal residual volume of the lungs is zero."
      , a = False
      , e = "The normal residual volume (i.e. the volume left in the lungs after fully exhaling) is always non-zero (i.e. there’s always a little bit of air left!), which prevents the lungs from fully collapsing."
      }
    , { q = "Ipratropium bromide is a muscarinic antagonist."
      , a = True
      , e = "The “parasympathetic”/muscarinic effect on the lungs is bronchoconstriction (i.e. the opposite of the “sympathetic”/adrenergic effect). By antagonising muscarinic receptors, the lungs become less prone to bronchoconstriction, making ipratropium bromide a useful medication for obstructive lung diseases."
      }
    , { q = "Finger clubbing is a feature of COPD."
      , a = False
      , e = "Finger clubbing is associated with many disorders, including many lung disorders (such as lung malignancies, cystic fibrosis and bronchiectasis), but is not classically associated with COPD. If you see finger clubbing in a patient with COPD, you should be suspicious of a sinister underlying pathology!"
      }
    , { q = "Severe hyperventilation is associated with respiratory alkalosis."
      , a = True
      , e = "In severe hyperventilation, carbon dioxide (acidic) is excessively removed from the body. The removal of an acid predisposes the body to an alkalotic state."
      }
    , { q = "Pulmonary vessels constrict around poorly ventilated regions of lung."
      , a = True
      , e = "Hypoxic pulmonary vasoconstriction is a compensatory mechanism to reduce the impact of ventilation-perfusion mismatch in the lungs. The body reduces blood flow around regions of lung which aren’t receiving much air flow, so it can divert the blood to better-ventilated areas. "
      }
    , { q = "An increase in blood pH increases the affinity of oxygen to haemoglobin."
      , a = False
      , e = "An increase in blood pH (such as near metabolically-active tissues producing acidic wastes and carbon dioxide) reduces the affinity of oxygen to haemoglobin, rather than increasing it. The inverse relationship between oxygen-haemoglobin affinity and pH is known as the Bohr effect, and makes it easier for haemoglobin to release its oxygen to tissues which need it. "
      }
    , { q = "The round ligament of the liver (ligamentum teres) is the degenerated remnant of the umbilical vein. "
      , a = True
      , e = "The umbilical vein carries oxygenated blood from the placenta towards the foetal heart (hence “vein”). It degenerates after birth to form the ligamentum teres (round ligament of the liver). The umbilical vein also leads to a shunt which bypasses the liver, called the ductus venosus, which degenerates to form the ligamentum venosum."
      }
    , { q = "Barret’s oesophagus refers to the replacement of normal columnar epithelium in the oesophagus with stratified squamous epithelium."
      , a = False
      , e = "The epithelium in the oesophagus is normal stratified squamous epithelium; Barrett’s oesophagus refers to the replacement of normal stratified squamous epithelium with columnar epithelium, similar to the epithelial protection of the intestines. This occurs in response to acidic exposure in the oesophagus, which transitions its epithelium to a more protective epithelium. "
      }
    , { q = "The greater curvature of the stomach is supplied by the short gastric arteries and the gastroepiploic/gastro-omental arteries."
      , a = True
      , e = "The short gastric arteries and the gastric branches of the left and right gastro-epiploic/gastro-omental arteries supply the greater curvature of the stomach."
      }
    , { q = "Hydrochloric acid in the stomach is produced by chief cells."
      , a = False
      , e = "Hydrochloric acid in the stomach is produced by parietal (aka oxyntic) cells, not chief cells. Chief cells instead produce pepsinogen to help break down ingested proteins."
      }
    , { q = "Histamine, acetylcholine and gastrin all increase the secretion of acid in the stomach."
      , a = True
      , e = "All three of histamine, acetylcholine and gastrin increase gastric acid secretion."
      }
    , { q = "Grey Turner's sign refers to bruising and discolouration around the umbilicus and may occur due to acute pancreatitis."
      , a = False
      , e = "Grey Turner's sign refers to bruising and discolouration around the flanks due to retroperitoneal haeomrrhage. Cullen's sign refers to bruising and discolouration around the umbilicus. Both may occur due to acute pancreatitis."
      }
    , { q = "Obstruction of the common bile duct leads to unconjugated hyperbilirubinaemia. "
      , a = False
      , e = "Bile acids are conjugated in the liver. The common bile duct is distal to the liver in the bile acid pathway, so obstruction of the common bile duct causes a conjugated hyperbilirubinaemia. Unconjugated hyperbilirubinaemia often occurs when bilirubin production overwhelms the liver's capacity to conjugate bilirubin, such as in haemolytic anaemia or genetic defects affecting liver enzymes. "
      }
    , { q = "Thiazide diuretics inhibit Na+/Cl- symporters in the distal convoluted tubule."
      , a = True
      , e = "Thiazide diuretics reduce sodium reabsorption in the distal convoluted tubule by inhibiting Na+/Cl- symporters, and therefore are used as anti-hypertensive agents (as a reduction in sodium reabsorption correspondingly reduces fluid reabsorption, and reduces blood pressure). "
      }
    , { q = "Renin is secreted by juxtaglomerular cells in the kidney."
      , a = True
      , e = "Juxtaglomerular cells secrete renin as a response to hypotension or a decrease in sodium ion concentration as detected by the macula densa. Secretion of renin stimulates the renin-angiotensin-aldosterone system to increase blood pressure. "
      }
    , { q = "GFR is best measured by the clearance rate of a substance which is secreted in the renal tubules but not reabsorbed. "
      , a = False
      , e = "GFR is best measured by a substance which is neither secreted nor reabsorbed, as the clearance of this substance would then be a direct measure of filtration. Inulin is an example of such a substance, though endogenous creatinine is often used in practice."
      }
    , { q = "Nephritic syndrome is characterised by gross proteinuria, oedema, hypoalbuminaemia and hyperlipidaemia."
      , a = False
      , e = "NephrItic syndrome refers to renal inflammation characterised mostly by the presence of red blood cells (blood) in the urine with possible other symptoms such as mild proteinuria, oedema and oliguria. Nephritic syndrome should not be confused with nephrOtic syndrome, which is characterised by the typical tetrad of gross proteinuria, oedema, hypoalbuminaemia and hyperlipidaemia."
      }
    , { q = "Loop diuretics increase the risk of hypokalaemia."
      , a = True
      , e = "Loop diuretics and thiazide diuretics both decrease sodium reabsorption prior to the distal segment of the distal convoluted tubule. The sodium-rich filtrate then induces increased action of a distal pump which uptakes sodium and secretes potassium and hydrogen ions, leading to hypokalaemia. This side effect of loop and thiazide diuretics is the whole reason why potassium-sparing diuretics are a thing!"
      }
    , { q = "Antidiuretic hormone is secreted by the anterior pituitary."
      , a = False
      , e = "Antidiuretic hormone (aka vasopressin) is one of only two hormones released by the posterior pituitary (produced by the hypothalamus), the other being oxytocin. The anterior pituitary releases (primarily) six hormones - FSH, LH, ACTH, TSH, prolactin and growth hormone (which can be remembered with FLAT PiG). "
      }
    , { q = "Neisseria meningitidis is a gram negative diplococcus."
      , a = True
      , e = "Neisseria meningitidis, often associated with meningitis, is a gram-negative diplococcus. This distinguishes it from another common cause of meningitis, Streptococcus pneumoniae, which is a gram-positive diplococcus."
      }
    , { q = "In a mental state examination, a metonym refers to the use of an entirely made-up word. "
      , a = False
      , e = "A metonym refers to the use of a closely associated (but real word) in an inappropriate context e.g. ‘I hate flying in pilots.’ A neologism refers to an entirely made-up word. Both are features of formal thoght disorder."
      }
    , { q = "Parkinson's disease is characterised by the death of dopaminergic neurons in the substantia nigra."
      , a = True
      , e = "Dopamine produced by neurons in the substantia nigra of the basal ganglia is essential for appropriate motor function. Parkinson's disease is characterised by motor deficits due to death of dopaminergic neurons in the substantia nigra."
      }
    , { q = "A homonymous superior quadrantanopia suggests a lesion to the contralateral parietal lobe."
      , a = False
      , e = "A homonymous superior quadrantanopia suggests a lesion to the contralateral temporal lobe (i.e. the inferior lobe/inferior optic radiations), not the parietal lobe. Just as lesions in the visual field suggest a deficit on the opposite horizontal axis, visual field lesions localisable to beyond the optic chiasm are also often the result of lesions on the opposite vertical axis. "
      }
    , { q = "The only muscle deriving from the third pharyngeal arch is the stylopharyngeus muscle."
      , a = True
      , e = "The third pharyngeal arch is the most boring muscular arch, giving rise to only one muscle (stylopharyngeus) which is supplied by the glossophayngeal nerve."
      }
    , { q = "Lateral medullary syndrome (of Wallenburg) typically occurs due to occlusion of the anterior inferior cerebellar artery."
      , a = False
      , e = "Lateral medullary syndrome typically results due to occlusion of the posterior inferior cerebellar artery (PICA). It is characterised by vestibular, cerebellar, palatal and contralateral spinothalamic dysfunction and an ipsilateral Horner's syndrome. Occlusion of the anteiror inferior cerebellar artery (AICA) results in lateral pontine syndrome (considering that the pons is anterior to the medulla), which manifests similarly to lateral medullary syndrome but also includes the cranial nerve nuclei present in the pons (e.g. the facial motor nucleus). "
      }
    , { q = "The facial nerve provides parasympathetic input to the submandibular and sublingual glands, but not the parotid gland."
      , a = True
      , e = "The facial nerve (CN VII) is one of four cranial nerves carrying parasympathetic fibres (remembered by the mnemonic 1973 – 10, 9, 7 and 3). The facial nerve parasympathetic fibres supply the salivary glands, except the parotid gland (which receives parasympathetic input from the glossopharyngeal nerve (CN IX))"
      }
    , { q = "The recurrent laryngeal nerves are branches of the hypoglossal nerve. "
      , a = False
      , e = "The recurrent laryngeal nerves are branches of the vagus nerve (and the sixth pharyngeal arch). These nerves are at high risk during thyroid surgery; damage can leave people voiceless, so much care is taken to avoid damaging these nerves. "
      }
    , { q = "Epidural haemorrhage usually occurs as a result of damage to the medial meningeal artery."
      , a = True
      , e = "Epidural haemorrhage is classically associated with traumatic damage (e.g. from a baseball) to the medial meningeal artery (a branch of the maxillary artery) as it passes near the pterion at the temples. "
      }
    , { q = "The foramen rotundum transmits the mandibular division of the trigeminal nerve."
      , a = False
      , e = "The foramen rotundum transmits the maxillary division (V2) of the trigeminal nerve.  The mandibular division (V3) of the trigeminal nerve is transmitted through the foramen ovale of the skull. A diagram helps! "
      }
    , { q = "Leydig cells in the testes produce testosterone in response to lutenising hormone."
      , a = True
      , e = "Leydig cells produce testosterone in response to lutenising hormone, in contrast with Sertoli cells (which secretes a number of non-testosterone substances in response to FSH)."
      }
    , { q = "21-hydroxylase deficiency causes an increase in mineralocorticoid production."
      , a = False
      , e = "21-hydroxylase deficiency is the most common form of congenital adrenal hyperplasia, and prevents (and therefore reduces) the synthesis of mineralocorticoids, resulting in difficulty maintaining blood volume. 17-alpha hydroxylase deficiency, on the other hand, prevents the synthesis of androgens and corticosteroids and increases mineralocorticoid production."
      }
    , { q = "During the menstrual cycle, progesterone is primarily produced by the corpus luteum."
      , a = True
      , e = "The corpus luteum forms after ovulation, and produces progesterone to maintain the endometrium during (possible) early pregnancy. In the absence of fertilisation, the corpus luteum degenerates and the menstrual cycle recommences."
      }
    , { q = "Vitamin B12 deficiency typically causes a microcytic anaemia."
      , a = False
      , e = "Both folate and Vitamin B12 deficiency typically manifest as megaloblastic, macrocytic anaemias, nor microcytic anaemias. Microcytic anaemia is typical of iron deficiency and thalassaemia. "
      }
    , { q = "Calcitonin is produced by parafollicular cells in the thyroid gland."
      , a = True
      , e = "Calcitonin is a hormone secreted by parafollicular cells (aka C cells) in the thyroid gland, and exerts the opposite action to parathyroid hormone (i.e. calcitonin tends to decrease bone resorption and decrease blood calcium)."
      }
    , { q = "Hypoglycaemia is a common adverse effect of metformin."
      , a = False
      , e = "Metformin, as opposed to sulfonylureas or insulin, has a relatively low risk of hypoglycaemia as it exerts its effect by increasing insulin sensitivity rather than by increasing insulin levels. Metformin does, however, have a (interesting) risk of lactic acidosis."
      }
    ]


dc : List Question
dc =
    [ { q = "A delta wave and short PR interval on an ECG are suggestive of Wolff-Parkinson-White syndrome"
      , a = True
      , e = "WPW occurs to an accessory conduction pathway in the heart which may conduct electrical impulses from the atria to the ventricles at a faster rate than usually allowed by the AV node (thereby shortening the PR interval and resulting in a premonitory upstroke). "
      }
    , { q = "Frusemide reduces mortality in patients with cardiac failure."
      , a = False
      , e = "Frusemide is used only to alleviate fluid overload symptoms in cardiac overload; a mortality benefit has not been shown. Drugs which have shown a mortality benefit in cardiac failure include ACE inhibitors, cardioselective beta blockers and spironolactone."
      }
    , { q = "Headaches are a common side effect of glyceryl trinitrate."
      , a = True
      , e = "Adverse effects commonly associated with GTN are headache, light-headedness and hypotension."
      }
    , { q = "Claudication relieved by leaning forward is typical of peripheral vascular disease"
      , a = False
      , e = "Relief from claudication by leaning forward (e.g. ‘pushing a shopping cart position’) is typical of neurogenic claudication (as this ‘opens’ the spinal canal) rather than vascular claudication (which is typically relieved by rest)."
      }
    , { q = "In aortic dissection, initial medical management should aim to reduce blood pressure."
      , a = True
      , e = "The acute management of aortic dissection should involve the reduction of blood pressure and heart rate, thereby reducing shear stress over the false lumen and often reducing concomitant hypertension. This is typically done by administering fast-acting beta blockers such as esmolol, as well as vasodilators such as sodium nitroprusside."
      }
    , { q = "Gout is a compelling contraindication to the use of beta blockers for treating hypertension."
      , a = False
      , e = "Gout is a compelling contraindication to the use of diuretics for treating hypertension (as diuretics may precipitate gout), not beta blockers. One compelling contraindication to beta blockers is asthma/COPD or heart block (which beta blockers may exacerbate). "
      }
    , { q = "A wide pulse pressure and waterhammer pulse are characteristic of aortic regurgitation."
      , a = True
      , e = "A wide pulse pressure (i.e. a large difference between systolic and diastolic blood pressure) and a ‘waterhammer’, ‘collapsing’ pulse are due to the backflow of blood through the aortic valve after the initial ejection from the left ventricle."
      }
    , { q = "Pneumococcal and annual influenza vaccination are recommended for patients with COPD."
      , a = True
      , e = "Influenza and pneumococcal immunisations are recommended by COPD-X guidelines to reduce the risk of hospitalisation and acute exacerbations. "
      }
    , { q = "Decreased tactile fremitus and hyperresonance to percussion are suggestive of pneumonia."
      , a = False
      , e = "Clinical features of pneumonia include increased tactile fremitus (due to consolidation) and dullness to percussion (due to consolidation)."
      }
    , { q = "If isoniazid is being used to treat tuberculosis, pyridoxine should also be given to reduce the risk of peripheral neuropathy."
      , a = True
      , e = "One adverse effect of isioniazid is peripheral neuropathy due to interference with pyridoxine metabolism.  Pyridoxine should therefore be added to a tuberculosis regimen including isoniazid.  "
      }
    , { q = "Adenocarcinoma of the lung tends to be located centrally in the lung."
      , a = False
      , e = "Adenocarcinoma of the lung tends to be located peripherally in the lung, not centrally. Squamous cell carcinoma of the lung tends to be located centrally."
      }
    , { q = "A high content of protein in a pleural effusion is suggestive of an exudative effusion."
      , a = True
      , e = "Light’s criteria are sometimes used to distinguish between transudative and exudative pleural effusions.  One such criteria is a high protein content of the effusion (relative to serum). "
      }
    , { q = "Fibroadenomas of the breast are a precancerous lesion."
      , a = False
      , e = "Fibroadenomas are common, benign tumours of breast tissue. They are not precancerous and not usually associated with an increase in the risk of breast cancer."
      }
    , { q = "Triple therapy against H. pylori-associated peptic ulcers typically involves a proton pump inhibitor, amoxycillin and clarithromycin."
      , a = True
      , e = "Triple therapy aims to treat H. pylori infection (with amoxicyllin and clarithromycin) and reduce the production of gastric acid (using a PPI)."
      }
    , { q = "Cullen’s sign and Grey-Turner’s sign are associated with acute pancreatitis."
      , a = True
      , e = "Cullen’s sign (umbilical bruising) and Grey-Turner’s sign (discolouration around the flanks) are often associated with acute pancreatitis, due to haemorrhage or necrotic products."
      }
    , { q = "Smoking increases the risk and severity of ulcerative colitis."
      , a = False
      , e = "Interestingly, smoking appears to decrease the risk and severity of ulcerative colitis. Resuming or starting smoking appears to reduce symptoms (though this is not a reason to encourage smoking!). This is not true of Crohn’s disease, where smoking appears to increase the risk and severity."
      }
    , { q = "Crohn’s disease commonly affects the terminal ileum, though may affect any part of the bowel in disparate regions (‘skip lesions’)."
      , a = True
      , e = "Unlike ulcerative colitis, Crohn’s disease may present as patchy, discontinuous regions of inflammation in the bowel and commonly affects the terminal ileum."
      }
    , { q = "Indirect inguinal hernias herniate medial to the inferior epigastric artery."
      , a = False
      , e = "Indirect inguinal hernias pass through the deep inguinal ring, lateral to the inferior epigastric artery. They are due to a developmental defect the abdominal wall and occur more commonly in children."
      }
    , { q = "Abdominal pain in diverticular disease is usually relieved by defecation."
      , a = True
      , e = "Classically, the abdominal pain of diverticular disease (if there are symptoms at all) is a recurrent left-lower quadrant pain relieved by defecation, when the pressure inside the bowel lowers. "
      }
    , { q = "Dermatitis herpetiformis is associated with inflammatory bowel disease."
      , a = False
      , e = "Dermatitis herpetiformis is an itchy, blistering rash over the shins which is associated with Coeliac disease, not IBD."
      }
    , { q = "Villous blunting and crypt hyperplasia are pathological features of bowel in Coeliac disease."
      , a = True
      , e = "Pathological manifestations of Coeliac disease include villous atrophy (resulting in malabsorption), elongated intestinal crypts and intraepithelial lymphocytes."
      }
    , { q = "Hepatitis A typically results in chronic liver inflammation."
      , a = False
      , e = "Hepatitis A does not generally cause chronic disease (unlikely Hepatitis B and Hepatitis C). Hepatitis A usually manifests as an acute diarrhoeal illness, particularly in returned travellers."
      }
    , { q = "The presence of anti-Hepatitis B core antibody in the blood cannot be due to Hepatitis B vaccination."
      , a = True
      , e = "Hepatitis B vaccination will only produce hepatitis B surface antibodies, not Hepatitis B core antibodies. Hepatitis B core antibodies must be produced by either active or prior exposure to Hepatitis B."
      }
    , { q = "Haemolytic jaundice typically results in conjugated hyperbilirubinaemia."
      , a = False
      , e = "Haemolytic jaundice, such as in G6PD deficiency, typically results in unconjugated hyperbilirubinaemia because the breakdown of red blood cells exceeds the liver’s capacity to conjugate bilirubin."
      }
    , { q = "Murphy’s sign is suggestive of cholecystitis."
      , a = True
      , e = "Murphy’s sign (a painful reaction upon inhaling when the examiner’s hand is placed at the right costal margin) is suggestive of inflammation of the gallbladder as occurs in cholecystitis."
      }
    , { q = "Painless jaundice in a patient with a palpable gallbladder is suggestive of gallstones."
      , a = False
      , e = "Courvoisier’s Law states that painless jaundice and a palpable gallbladder are suggestive of a cause other than gallstones, particularly pancreatic malignancy (or other obstructive malignancy). Prolonged gallstones typically causes a fibrotic gallbladder which is unlikely to be distended."
      }
    , { q = "A high BUN:Cr ratio in acute kidney injury suggests a pre-renal cause."
      , a = True
      , e = "Urea and creatinine are both freely filtered, but urea is reabsorbed while creatinine is (mostly) not. In pre-renal failure, urea reabsorption increases with the increase in sodium and water reabsorption whereas creatinine does not, so the BUN:Cr ratio increases."
      }
    , { q = "Focal segmental glomerulosclerosis is a type of nephritic syndrome."
      , a = False
      , e = "FSGS is an example of a nephrotic syndrome, not a nephritic syndrome. FSGS is a heterogeneous disease classification, and may be primary or secondary to toxins, or nephron-damaging diseases."
      }
    , { q = "UTIs are most commonly caused by E. coli infection."
      , a = True
      , e = "The most common UTI pathogen (where there is no special predisposing factors such as catheter use) is E. coli. Others include Klebsiella species, Proteus mirabilis, and Staphylococcus saprophyticus."
      }
    , { q = "Benign prostatic hypertrophy typically affects the peripheral zone of the prostate."
      , a = False
      , e = "BPH typically affects the central zone of the prostate, not the peripheral zone (and hence present with more prominent obstructive symptoms). Prostatic adenocarcinomas typically affect the peripheral zone of the prostate."
      }
    , { q = "Diabetic ketoacidosis may result in deep laboured breaths known as Kussmaul breathing."
      , a = True
      , e = "Kussmaul breathing refers to deep, laboured breaths which may occur due to severe metabolic acidosis (as occurs in diabetic acidosis) as a means of blowing off acidic carbon dioxide."
      }
    , { q = "Pretibial myxoedema is suggestive of hypothyroidism."
      , a = False
      , e = "Despite the fact that ‘myxoedema’ means severe hypothyroidism, ‘pretibial myxoedema’ refers to a waxy non-pitting oedema over the shins due to Grave’s disease rather than hypothyroidism."
      }
    , { q = "‘Hot’ thyroid nodules are not usually malignant."
      , a = True
      , e = "‘Hot’ thyroid nodules (hyperfunction) tend to reduce the suspicion of a nodule being malignant, as malignant nodules tend to be ‘cold’ (non-functioning). "
      }
    , { q = "A bone mineral density Z-score below 2.5 is used to diagnose osteoporosis."
      , a = False
      , e = "A bone-mineral dinesity T-score below 2.5 is used to diagnose osteoporosis. BMD Z-scores (same as the statistical Z-score) compare bone mineral density to age-matched adults, whereas a T-score compares bone mineral density to a healthy young adult (i.e. it does not matter what age you are). Osteoporosis is diagnosed for brittle bones, and a brittle bone is brittle whether you are young or old!"
      }
    , { q = "Cluster headaches often occur with autonomic symptoms such as rhinorrhoea or tearing around the eye."
      , a = True
      , e = "Cluster headaches are also known as trigeminal autonomic cephalgias due to their trigeminal distribution (classicaly retroorbital) and association with autonomic symptoms."
      }
    , { q = "Triptans are used for migraine prophylaxis."
      , a = False
      , e = "Triptans are sometimes used in the acute treatment of migraines; they are not useful as prophylaxis. Migraine prophylaxis drugs include propranolol, amitryptyline, verapamil and pizotifen. "
      }
    , { q = "Automatisms are a feature of complex partial seizures (aka seizures with dyscognitive features)."
      , a = True
      , e = "Automatisms are unconscious behaviours such as finger picking or lip smacking. The fact that they are ‘unconscious’ behaviours (i.e. the patient is not aware of them) should point out that these are features of complex partial seizures/seizures with dyscognitive features (where awareness is lost)."
      }
    , { q = "CSF examination in bacterial meningitis usually demonstrates an increase in lymphocytes and protein, and a reduction in glucose."
      , a = False
      , e = "Bacterial meningitis typically causes an increase in neutrophils (aka polymorphs) and protein in CSF (and a reduction in glucose). Lymphocytes are typically seen in either viral or fungal meningitis."
      }
    , { q = "Haemolysis may result in an increase in LDH and a decrease in haptoglobin."
      , a = True
      , e = "LDH is increased during haemolysis (as it is released on breakdown) whereas haptoglobin is decreased during haemolysis (as it binds to free haemoglobin). "
      }
    , { q = "Bouchard’s and Heberden’s nodes are suggestive of rheumatoid arthritis."
      , a = False
      , e = "Bouchard’s and Heberden’s nodes are suggestive of osteoarthritis (due to bony spurs), not rheumatoid arthritis (which typically results in deformities such as swan-neck deformity and Z-thumb deformity)"
      }
    ]


dd : List Question
dd =
    [ { q = "IVIG and aspirin are used as first-line therapy for Kawasaki disease."
      , a = True
      , e = "Kawasaki disease is an autoimmune vasculitis which confers a risk of developing coronary artery aneurysms (which can be fatal).  Prompt treatment with aspirin and IVIG is therefore recommended. "
      }
    , { q = "Croup is typically caused by respiratory syncitial virus (RSV)."
      , a = False
      , e = "Croup is a disease of ‘older’ children (around 6 months to 6 years) typically caused by parainfluenza virus. RSV is typically associated with bronchiolitis, a disease of ‘younger’ children (typically less than 6 months). "
      }
    , { q = "Pyloric stenosis may lead to hypochloraemic metabolic alkalosis."
      , a = True
      , e = "Due to the profuse vomiting produced by pyloric stenosis, infants may lose significant quantities of gastric acid, resulting in hypochloremic metabolic alkalosis."
      }
    , { q = "Bacterial streptococcal pharyngitis is treated with amoxicillin."
      , a = False
      , e = "Amoxicillin should never be used to treat bacterial streptococcus pharyngitis, as it is unnecessarily broad-spectrum and may cause a rash if there is concomitant (or incorrectly diagnosed) EBV infection. If antibiotic therapy is warranted, phenoxymethylpenicillin (penicillin V) is the antibiotic of choice."
      }
    , { q = "‘Red currant jelly’ stools and colicky abdominal pain are suggestive of intussusception."
      , a = True
      , e = "Intussusception occurs due to telescoping of proximal bowel with distal bowel; bowel contractions lead to colicky abdominal pain, and necrosis can lead to the presence of ‘currant jelly’-like stool in infants."
      }
    , { q = "“Slapped cheek syndrome” (fifth disease) is a childhood skin infection caused by staphylococcus aureus."
      , a = False
      , e = "'Slapped cheek syndrome’ is a viral exanthem caused by parvovirus B19. While staphylococcus aureus is responsible for many skin infections (e.g. impetigo), it is not responsible for this one (or any of the viral exanthems for that matter)."
      }
    , { q = "If a preventer medication is needed for the treatment of asthma, LABA monotherapy should be trialled first."
      , a = False
      , e = "LABAs should never be administered as monotherapy in asthma, as they appear to increase the risk of life-threatening asthma attacks. The first preventer which should be tried is low-dose inhaled corticosteroids."
      }
    , { q = "Vaccination to protect against varicella is first given at 18 months of age."
      , a = True
      , e = "The first varicella-protective vaccine is given with the MMRV vaccine at 18 months. Note that the MMR vaccine (without varicella) is first given at 12 months."
      }
    , { q = "A hydrocoele typically transilluminates when a light is held against the affected testis."
      , a = True
      , e = "Hydrocoeles, as opposed to solid tumour swellings, typically transilluminate on clinical examination when a light is held against the affected area."
      }
    , { q = "The Barlow manoeuvre is used to screen infants for birth trauma."
      , a = False
      , e = "The Barlow manoeuvre is a test for developmental dysplasia of the hip, performed by adducting the hip and applying a force posteriorly, and looking for dislocation (demonstrating instability of the hip joint). "
      }
    , { q = "The Rinne test is negative in conductive hearing loss."
      , a = True
      , e = "Unlike most tests, a ‘positive’ Rinne test is the normal test (demonstrating air conduction is better than bone conduction). A negative Rinne test suggests conductive hearing loss."
      }
    , { q = "A ‘blood and thunder’ appearance of the retina is associated with a central retinal artery occlusion."
      , a = False
      , e = "A ‘blood and thunder’ appearance of the retina is associated with a central retinal vein occlusion due to haemorrhage and oedema. An arterial occlusion involving the retina typically results in a pale fundus (with a “cherry red macula”)."
      }
    , { q = "Psoriasis is typically described as sharply-demarcated, salmon-pink lesions with silver scale."
      , a = True
      , e = "Psoriasis and eczema are often confused. Psoriasis is characterised by well-defined salmon-pink lesions with silvery scale, whereas eczema is typically described as oozing, crusty lesions with intense itch."
      }
    , { q = "Pregnant women should not receive the influenza vaccine."
      , a = False
      , e = "The influenza vaccine is recommended for pregnant women (as well as the pertussis vaccine as a single dose in the second or third trimester). "
      }
    , { q = "In palliative care, nausea and vomiting due to poor gastric emptying is treated with a prokinetic such as metoclopramide."
      , a = True
      , e = "The first-line palliative treatment of nausea and vomiting due to poor gastric emptying is a prokinetic such as metoclopramide or domperidone. However, if mechanical bowel obstruction is suspected, these medications are contraindicated."
      }
    , { q = "McMurray’s test tests for tears of the anterior or posterior cruciate ligament."
      , a = False
      , e = "McMurray’s test is a rotational test evaluating for meniscal tears. The anterior drawer and posterior drawer tests are used to test the anterior and posterior cruciate ligaments."
      }
    , { q = "In first aid treatment of anaphylaxis, the patient should not be allowed to stand or walk."
      , a = True
      , e = "Standing (or an upright positional change) can rapidly provoke a drop in blood pressure and, in severe cases, complete loss of venous return and cardiac output in anaphylaxis. This can (and has been) fatal. Patients should not be allowed to stand or walk during the first aid management of an anaphylactic reaction."
      }
    , { q = "The recommended treatment for primary syphillis is metronidazole."
      , a = False
      , e = "The recommended treatment for primary syphillis is a 1.8g stat injection of benzathine penicillin, a long-acting antibiotic."
      }
    , { q = "In the diabetes annual cycle of care, a comprehensive ophthalmic examination is recommended at least every 2 years."
      , a = True
      , e = "The diabetes annual cycle of care specifies minimum frequencies of certain investigations for monitoring diabetes; a comprehensive eye examination is the most infrequent item, recommended at least every 2 years."
      }
    , { q = "Bowel cancer screening is recommended every 5 years from ages 50 to 74."
      , a = False
      , e = "The National Bowel Cancer Screening Program offers screening every 2 years using a FOBT from ages 50 to 74. "
      }
    , { q = "Mullerian agenesis results in incomplete development of a uterus but normal secondary sexual characteristics."
      , a = True
      , e = "Mullerian agenesis (aka Mayer-Rokitansky-Kuster-Hauser syndrome) is caused by a failure of Mullerian duct structures to develop (including the uterus); however, as the ovaries are still intact, secondary sexual characteristics still develop."
      }
    , { q = "Bacterial vaginosis is often caused by Candida species. "
      , a = False
      , e = "Bacterial vaginosis is typically caused by overgrowth of normal vaginal flora. It is not to be confused with vaginal yeast infections, which are caused by Candida species."
      }
    , { q = "Submucosal fibroids are associated with bleeding and infertility."
      , a = True
      , e = "Most fibroids are asymptomatic; however, submucosal fibroids (which project into the uterine cavity) can affect the ability of the uterus to support a pregnancy and are more prone to intrauterine bleeding."
      }
    , { q = "The combined oral contraceptive pill increases the risk of endometrial and ovarian carcinoma."
      , a = False
      , e = "The COCP decreases the risk of endometrial and ovarian carcinoma, rather than increasing it. There may be an increased risk of breast cancer, however."
      }
    , { q = "Endometriomas are associated with a diffuse, homogenous ground-glass appearance on ultrasound."
      , a = True
      , e = "Ultrasound of endometriomas typically shows diffuse, low-level echoes in a ground-glass-like pattern. "
      }
    , { q = "A woman with O Rh+ve blood should receive anti-D antibody within 72 hours of miscarriage."
      , a = False
      , e = "Rhesus alloimmunisation is only a risk for women with a Rhesus negative blood type. A woman with Rhesus positive blood will not develop antibodies to fetal Rhesus positive blood. "
      }
    , { q = "Estrogen-only hormone replacement therapy is suitable for women with a hysterectomy."
      , a = True
      , e = "Progesterone is usually required to be given with estrogen for HRT (as omitting it increases the risk of endometrial hyperplasia and cancer), but this is not a requirement when there is no longer an endometrium."
      }
    , { q = "Fetal heart rate accelerations associated with fetal movements indicate poor blood supply."
      , a = False
      , e = "Fetal heart rate accelerations in conjunction with fetal movements are a reassuring sign, indicating sufficient vascular supply and activity. "
      }
    , { q = "The uterosacral ligament may be affected by endometriosis and result in a palpable nodularity."
      , a = True
      , e = "Endometriosis can affect the uterosacrine ligaments, which may cause a palpable nodularity on vaginal examination through the vaginal wall."
      }
    , { q = "HPV strains 6 and 11 are high-risk strains for cervical cancer."
      , a = False
      , e = "HPV straing 6 and 11 are low-risk strains associated with condyloma. The most well-known high-risk strains are HPV 16 and HPV 18, which were the original high-risk targets of the quadrivalent HPV vaccine. "
      }
    , { q = "For schizophrenia to be diagnosed, symptoms must have occurred for a portion of time over at least a 6 month period. "
      , a = True
      , e = "Schizophrenia is a chronic condition, and can only be diagnosed when symptoms (some of which must occur during the same 1-month period) occur for at least 6 months."
      }
    , { q = "Hallucinations are a feature of hypomanic episodes."
      , a = False
      , e = "Psychotic features are a characteristic of manic episodes, not hypomanic episodes."
      }
    , { q = "Vascular dementia it typically characterised by a step-wise deterioration in cognitive function."
      , a = True
      , e = "Vascular dementia occurs due to cerebral infarction; step-wise deterioration is typical, due to the occurrence of discrete infarcts."
      }
    , { q = "Schizoid personality disorder is characterised by ‘magical thinking’ and bizarre beliefs."
      , a = False
      , e = "Schizoid personality disorder is characterised by aloof and a lack of interest in social relationships. It is not to be confused with schizotypal personality disorder, which is associated with bizarre beliefs and psychosis-like symptoms."
      }
    , { q = "The maximum duration of a Temporary Treatment Order under the Mental Health Act is 28 days."
      , a = True
      , e = "A Temporary Treatment Order authorises a psychiatrist to provide temporary compulsory mental health treatment over a maximum duration of 28 days. If it is not revoked before 28 days, a hearing will be scheduled to determine whether a Treatment Order is required. "
      }
    , { q = "Tricyclic antidepressants are a first-line pharmacological treatment for depression."
      , a = False
      , e = "Tricyclic antidepressants are no longer first-line pharmacological treatments for depression. First-line agents for depression include SSRIs, SNRIs or mirtazepine."
      }
    , { q = "Side effects of mirtazepine include weight gain and sedation."
      , a = True
      , e = "Mirtazepine may cause weight gain and sedation, which may actually be desirable if patients are underweight and experience insomnia. Mirtazepine is given at night due to its sedative actions."
      }
    , { q = "Olanzepine has a high risk of extrapyramidal side effects."
      , a = False
      , e = "Olanzepine is an atypical antipsychotic, and has a comparatively low risk of extrapyramidal side effects compred to typical antipsychotics such as haloperidol. Instead, olanzepine has prominent metabolic side effects such as weight gain and hyperlipidaemia."
      }
    , { q = "Dialetical behaviour therapy (DBT) is a specialised form of psychotherapy for borderline personality disorder."
      , a = True
      , e = "DBT is designed in particular for targeting the maladaptive emotional and behavioural patterns of borderline personality disorder using cognitive behavioural techniques."
      }
    , { q = "Fluoxetine is an SSRI with a short-half life and therefore needs to be monitored carefully."
      , a = False
      , e = "Fluoxetine has the longest half life of most popular SSRIs due to its conversion to an active metabolite, norfluoxetine. When pharmacological therapy is indicated in children, it is the drug of choice."
      }
    ]
