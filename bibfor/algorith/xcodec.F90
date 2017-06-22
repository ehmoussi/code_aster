! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine xcodec(noma, modelx, k8condi, linter, decou)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
#include "asterfort/xaint2.h"
#include "asterfort/xconno.h"
#include "asterfort/xfisco.h"
#include "asterfort/xfisno.h"
#include "asterfort/xjonct.h"
#include "asterfort/xoripe.h"
#include "asterfort/xstan2.h"
#include "asterfort/xtopoc.h"
#include "asterfort/xtopoh.h"
#include "asterfort/xtopoi.h"
#include "asterfort/exi_fiss.h"
    character(len=8) :: noma, modelx, k8condi, decou
    character(len=19) :: ligre1, maxfem
    integer :: jcond
    aster_logical :: linter, lfiss
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (MODIF. DU MODELE)
!
! CALCUL DU DÉCOUPAGE EN SOUS-TETRAS, DES FACETTES DE CONTACT
! ET VERIFICATION DES CRITERES DE CONDITIONNEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  MODELX : NOM DU MODELE XFEM MODIFIE
!
!
!
!
    character(len=19) :: ltno, lnno, stno, basloc, grlnno, grltno
    character(len=16) :: optrig
    real(kind=8) :: crit2(2)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- CONCATENER LES CHAMPS NODAUX POUR DES FISSURES DU MODELE
!
    optrig = 'INI_XFEM_ELNO'
    ltno = modelx(1:8)//'.LTNO'
    lnno = modelx(1:8)//'.LNNO'
    stno = modelx(1:8)//'.STNO'
    basloc = modelx(1:8)//'.BASLOC'
    grlnno = modelx(1:8)//'.GRLNNO'
    grltno = modelx(1:8)//'.GRLTNO'
    call xconno(modelx, '.STNO      ', 'G', optrig, 'PSTANO',&
                stno)
    call xconno(modelx, '.LNNO      ', 'G', optrig, 'PLSN',&
                lnno)
    call xconno(modelx, '.LTNO      ', 'G', optrig, 'PLST',&
                ltno)
    call xconno(modelx, '.BASLOC    ', 'G', optrig, 'PBASLOR',&
                basloc)
    call xconno(modelx, '.GRLNNO    ', 'V', 'TOPOFA', 'PGRADLN',&
                grlnno)
    call xconno(modelx, '.GRLTNO    ', 'V', 'TOPOFA', 'PGRADLT',&
                grltno)
!
! --- UTILE POUR LES INTERSECTIONS
!
    if (linter) then
        call xfisno(noma, modelx)
        call xfisco(noma, modelx)
    endif
!
! --- CALCUL DES DONNEES UTILES POUR L'INTÉGRATION (SOUS-TETRAS...)
!
    call xtopoi(noma, modelx)
!
! --- UTILE POUR LES INTERSECTIONS
!
    if (linter) then
        call xjonct(noma, modelx)
    endif
!
! --- CALCUL DE LA TOPOLOGIE DES FACETTES DE CONTACT
!
    call xtopoc(modelx, decou)
!
! --- REDEFINITION DES FONCTIONS HEAVISIDE PAR NOEUD
!
    call xtopoh(noma, modelx)
!
! --- ON MODIFIE MODELX(1:8)//'TOPOFAC.AI' POUR LE MULTI-HEAVISIDE
!
    if (linter) then
        call xaint2(noma, modelx)
    endif
!
! --- ON MODIFIE MODELX(1:8)//'.PRE_COND' POUR L ACTIVATION DU PRE CONDITIONNEUR XFEM
! --- ON MODIFIE MODELX(1:8)//'.STNO' POUR LE CONDITIONNEMENT HEAVISIDE
    call wkvect(modelx//'.PRE_COND', 'G V K8', 1, jcond)
! --- ON DURCIT LE CRITERE POUR LES FISSURES :
!        * DANS CE CAS LA PRECISION SUR L INTERFACE EST NEGLIGEABLE
!            DEVANT L INCERTITUDE EN FOND DE FISSURE
    lfiss=exi_fiss(modelx)        
    if ( k8condi .eq. 'AUTO' ) then
       call dismoi('NOM_LIGREL', modelx, 'MODELE', repk=ligre1)
       call dismoi('LINE_QUAD', ligre1, 'LIGREL', repk=maxfem)
       if (maxfem .ne. 'LINE') then
         if (lfiss) then
          crit2(1)=1.d-6
          crit2(2)=1.d-4
         else
          crit2(1)=1.d-6
          crit2(2)=1.d-5
         endif
          zk8(jcond)='OUI'        
       else
          crit2(1)=1.d-8
          crit2(2)=1.d-5
          zk8(jcond)='OUI'
       endif
    elseif ( k8condi .eq. 'FORCE' ) then
       crit2(1)=1.d-8
       crit2(2)=1.d-5
       zk8(jcond)='OUI'
    elseif ( k8condi .eq. 'SANS' ) then
       crit2(1)=1.d-4
       crit2(2)=1.d-4
       zk8(jcond)='NON'
    else
       ASSERT(.false.)
    endif
!
!   ON MET EN PLACE UN CRITERE A 2 NIVEAUX:
!   CRIT2(1) => POUR LES NOEUDS SOMMETS
!   CRIT2(2) => POUR LES NOEUDS MILIEUX
!
    call xstan2(noma, modelx, crit2, lfiss)
!
! --- ORIENTATION DES FACETTES DE PEAU X-FEM (COMME ORIE_PEAU)
!
    call xoripe(modelx)
!
!
    call jedema()
end subroutine
