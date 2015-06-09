subroutine meachc(modele, fomult, lischa, partps, numedd,&
                  cnchci)
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asasve.h"
#include "asterfort/ascavc.h"
#include "asterfort/ascova.h"
#include "asterfort/detrsd.h"
#include "asterfort/fetccn.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmvcd2.h"
#include "asterfort/nmvcex.h"
#include "asterfort/nmvcle.h"
#include "asterfort/vechme.h"
#include "asterfort/vectme.h"
#include "asterfort/vecvme.h"
#include "asterfort/vedime.h"
#include "asterfort/velame.h"
#include "asterfort/vrcref.h"
    character(len=19) :: lischa
    character(len=24) :: cnchci, modele, fomult, numedd
    real(kind=8) :: partps(3)
!
! ----------------------------------------------------------------------
!     MECANIQUE STATIQUE - ACTUALISATION DES CHARGEMENTS MECANIQUES
!     **                   *                 **          *
! ----------------------------------------------------------------------
! IN  MODELE  : NOM DU MODELE
! IN  FOMULT  : LISTE DES FONCTIONS MULTIPLICATRICES
! IN  LISCHA  : INFORMATION SUR LES CHARGEMENTS
! IN  PARTPS  : PARAMETRES TEMPORELS
! IN  NUMEDD  : PROFIL DE LA MATRICE
! OUT CNCHCI  : OBJET DE S.D. CHAM_NO DIMENSIONNE A LA TAILLE DU
!               PROBLEME, VALANT 0 PARTOUT, SAUF LA OU LES DDLS IMPOSES
!               SONT TRAITES PAR ELIMINATION (= DEPLACEMENT IMPOSE)
!----------------------------------------------------------------------
!
!
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
    real(kind=8) :: time
    character(len=24) :: charge, infoch
!
! DEB-------------------------------------------------------------------
!====
! 1. PREALABLES
!====
!
    call jemarq()
!
!====
! 2. CHARGES CINEMATIQUES
!====
!
    cnchci = ' '
    time = partps(1)
    charge = lischa//'.LCHA'
    infoch = lischa//'.INFC'
    call ascavc(charge, infoch, fomult, numedd, time,&
                cnchci)
!
    call jedema()
end subroutine
