
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

namespace ArturHKBA.Vrc
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class ResetSwitch : UdonSharpBehaviour
    {
        // Dieses Script setzt die ausgewählten Prefabs innerhalb des Komponenten Tabs zurück

        [SerializeField, Header("ZURÜCKSETZEN")] GameObject[] targets;

        private int _num;
        private Vector3[] _initPositions;
        private Quaternion[] _initRotations;
        private VRCPlayerApi _localPlayer;

        private void Start()
        {
            _num = targets.Length;
            _initPositions = new Vector3[_num];
            _initRotations = new Quaternion[_num];
            SetInitPosRot();
        }

        public override void Interact()
        {
            for (int i = 0; i < _num; ++i)
            {
                if (targets[i])
                {
                    ResetUdonBehaviour(targets[i]);
                    ResetPosRot(i);
                }
            }
        }

        /// <summary>
        /// Die position speichern
        /// </summary>
        private void SetInitPosRot()
        {
            for (int i = 0; i < _num; i++)
            {
                if (targets[i])
                {
                    _initPositions[i] = targets[i].transform.position;
                    _initRotations[i] = targets[i].transform.rotation;
                }
            }
        }

        /// <summary>
        /// Position zurücksetzen (Index)
        /// </summary>
        /// <param name="index">DEFAULT</param>
        private void ResetPosRot(int index)
        {
            VRCPickup pickup = targets[index].GetComponent<VRCPickup>();
            if (!pickup)
            {
                // Wenn keine Positionsänderung erforderlich ist

                return;
            }

            // Ownership wird geprüft und erteilt

            if (!Networking.IsOwner(targets[index]))
            {
                if (_localPlayer == null)
                {
                    _localPlayer = Networking.LocalPlayer;
                }
                Networking.SetOwner(_localPlayer, targets[index]);
            }

            // Positionen werden synchronisiert

            VRCObjectSync objSync = targets[index].GetComponent<VRCObjectSync>();
            if (objSync)
            {
                objSync.FlagDiscontinuity();
            }
            Rigidbody rd = targets[index].GetComponent<Rigidbody>();
            if (rd)
            {
                rd.Sleep();
            }
            targets[index].transform.SetPositionAndRotation(_initPositions[index], _initRotations[index]);
        }

        /// <summary>
        /// UdonBevaiourALLE "ZURÜCKSETZEN" wird ausgeführt
        /// </summary>
        /// <param name="go">Das Ziel</param>
        private void ResetUdonBehaviour(GameObject go)
        {
            UdonBehaviour[] udons = go.GetComponents<UdonBehaviour>();
            ResetUdonBahaviourSub(udons);

            udons = go.GetComponentsInChildren<UdonBehaviour>();
            ResetUdonBahaviourSub(udons);
        }

        private void ResetUdonBahaviourSub(UdonBehaviour[] udons)
        {
            foreach (UdonBehaviour udon in udons)
            {
                // Der Besitzer (Ownership) kann nun alles zurücksetzen
                
                udon.SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.Owner, "ResetAll");
            }
        }
    }
}