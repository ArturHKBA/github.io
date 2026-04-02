using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
// NavMeshAgent

public class SimpleAiPatrol : MonoBehaviour
{
    private NavMeshAgent agent;
    [SerializeField] private Vector3 firstPosOffset;
    [SerializeField] private Vector3 secondPosOffset;
    public enum AIState { Patrol, Attack, Idle}
    public AIState currentAiState;
    private FieldOfView fieldOfView;
    [SerializeField] private float viewRadius = 15f;
    [Range(0, 360)][SerializeField] private float viewAngle = 15f;
    private bool idleStop = false;
    private bool patrolMove = false;
    [HideInInspector] public bool isAttacking = false;
    private FaceObjectTowardPlayer faceTowardPlayer;
    [SerializeField] private float stopDistanceFromPlayer = 10f;
    private GegnerHealth gegnerHealth;

    void Start()
    {
        gegnerHealth = GetComponent<GegnerHealth>();
        faceTowardPlayer =GetComponentInChildren<FaceObjectTowardPlayer>();
        isAttacking = false;
        fieldOfView = GetComponent<FieldOfView>();
        fieldOfView.viewRadius = viewRadius;    
        fieldOfView.viewAngle = viewAngle;

        firstPosOffset = transform.position + firstPosOffset;
        secondPosOffset = transform.position + secondPosOffset;

        agent = GetComponent<NavMeshAgent>();

    }
    void OnDrawGizmos()
    {
        // Eine Grüne Kugel an der Position der "Transform"

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, stopDistanceFromPlayer);
    }
    private void LateUpdate()
    {
        switch (currentAiState)
        {
            case AIState.Patrol:
                Patrol();
                break;
            case AIState.Attack:
                Attack();
                break;
            case AIState.Idle:
                Idle();
                break;
        }

        if(gegnerHealth.gegnerGotHit)
        {
            currentAiState = AIState.Attack;
        }
    }
    private void Patrol()
    {
        // Patroliert zwischen Positionen A > B > C > A etc.

        if (!patrolMove)
        {
            // Das Ziel wird gesetzt

            agent.SetDestination(firstPosOffset);
        }
        else
        {
            //Das Ziel wird gesetzt

            agent.SetDestination(secondPosOffset);
        }

        // Das Ziel findet sein Ende

        if (Mathf.Abs(agent.nextPosition.z - firstPosOffset.z) <= 1 && Mathf.Abs(agent.nextPosition.x - firstPosOffset.x) <= 1)
        {
            patrolMove = true;
        }

        if (Mathf.Abs(agent.nextPosition.z - secondPosOffset.z) <= 1 && Mathf.Abs(agent.nextPosition.x - secondPosOffset.x) <= 1)
        {
            patrolMove = false;
        }


        SearchForPlayer();
    }
    private void Attack()
    {
        isAttacking = true;

        if (faceTowardPlayer.playerObj != null)
        {

            if (Vector3.Distance(transform.position, faceTowardPlayer.playerObj.transform.position) > stopDistanceFromPlayer)
            {
                agent.SetDestination(faceTowardPlayer.playerObj.transform.position);
            }
            else
            {
                RotateTowardsPlayerFunction();
                agent.SetDestination(transform.position);
            }
        }



    }
    private void Idle()
    {
        SearchForPlayer();
        if(idleStop == false)
        {
            agent.SetDestination(transform.position + firstPosOffset);
            idleStop = true;    
        }
    }

    private void SearchForPlayer()
    {
        for (int i = 0; i < fieldOfView.visibleTargets.Count; i++)
        {
            currentAiState = AIState.Attack;
        }
    }


    private void RotateTowardsPlayerFunction()
    {
        // Hierdurch dreht sich der Gegner zum Spieler

        Vector3 lookPos = faceTowardPlayer.playerObj.transform.position - transform.position;
        lookPos.y = 0;
        Quaternion rotation = Quaternion.LookRotation(lookPos);
        transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * 5);
    }

}
