//
//  Zap
//
//  Created by Otto Suess on 03.05.18.
//  Copyright © 2018 Zap. All rights reserved.
//

#if !REMOTEONLY

import Foundation
import Lndmobile
import LndRpc
import SwiftBTC

public final class LightningApiStream: LightningApiProtocol {
    public init() {}
    
    public func routes(destination: String, amount: Satoshi, completion: @escaping (Result<[Route], LndApiError>) -> Void) {
        let data = LNDQueryRoutesRequest(destination: destination, amount: amount).data()
        LndmobileQueryRoutes(data, StreamCallback(completion, map: LightningApiTransformations.routes))
    }
    
    public func info(completion: @escaping (Result<Info, LndApiError>) -> Void) {
        LndmobileGetInfo(nil, StreamCallback(completion, map: LightningApiTransformations.info))
    }
    
    public func nodeInfo(pubKey: String, completion: @escaping (Result<NodeInfo, LndApiError>) -> Void) {
        let data = LNDNodeInfoRequest(pubKey: pubKey).data()
        LndmobileGetNodeInfo(data, StreamCallback(completion, map: LightningApiTransformations.nodeInfo))
    }
    
    public func newAddress(type: OnChainRequestAddressType, completion: @escaping (Result<BitcoinAddress, LndApiError>) -> Void) {
        let data = LNDNewAddressRequest(type: type).data()
        LndmobileNewAddress(data, StreamCallback(completion, map: LightningApiTransformations.newAddress))
    }
    
    public func walletBalance(completion: @escaping (Result<Satoshi, LndApiError>) -> Void) {
        LndmobileWalletBalance(nil, StreamCallback(completion, map: LightningApiTransformations.walletBalance))
    }
    
    public func channelBalance(completion: @escaping (Result<Satoshi, LndApiError>) -> Void) {
        LndmobileChannelBalance(nil, StreamCallback(completion, map: LightningApiTransformations.channelBalance))
    }
    
    public func transactions(completion: @escaping (Result<[Transaction], LndApiError>) -> Void) {
        LndmobileGetTransactions(nil, StreamCallback(completion, map: LightningApiTransformations.transactions))
    }
    
    public func subscribeTransactions(completion: @escaping (Result<Transaction, LndApiError>) -> Void) {
        LndmobileSubscribeTransactions(nil, StreamCallback(completion, map: LightningApiTransformations.subscribeTransactions))
    }
    
    public func payments(completion: @escaping (Result<[Payment], LndApiError>) -> Void) {
        LndmobileListPayments(nil, StreamCallback(completion, map: LightningApiTransformations.payments))
    }
    
    public func channels(completion: @escaping (Result<[Channel], LndApiError>) -> Void) {
        LndmobileListChannels(nil, StreamCallback(completion, map: LightningApiTransformations.channels))
    }
    
    public func closedChannels(completion: @escaping (Result<[ChannelCloseSummary], LndApiError>) -> Void) {
        LndmobileClosedChannels(nil, StreamCallback(completion, map: LightningApiTransformations.closedChannels))
    }
    
    public func pendingChannels(completion: @escaping (Result<[Channel], LndApiError>) -> Void) {
        LndmobilePendingChannels(nil, StreamCallback(completion, map: LightningApiTransformations.pendingChannels))
    }
    
    public func connect(pubKey: String, host: String, completion: @escaping (Result<Success, LndApiError>) -> Void) {
        let data = LNDConnectPeerRequest(pubKey: pubKey, host: host).data()
        LndmobileConnectPeer(data, StreamCallback(completion, map: LightningApiTransformations.connect))
    }
    
    public func openChannel(pubKey: String, amount: Satoshi, completion: @escaping (Result<ChannelPoint, LndApiError>) -> Void) {
        let data = LNDOpenChannelRequest(pubKey: pubKey, amount: amount).data()
        LndmobileOpenChannelSync(data, StreamCallback(completion, map: LightningApiTransformations.openChannel))
    }
    
    public func closeChannel(channelPoint: ChannelPoint, force: Bool, completion: @escaping (Result<CloseStatusUpdate, LndApiError>) -> Void) {
        if let data = LNDCloseChannelRequest(channelPoint: channelPoint, force: force)?.data() {
            LndmobileCloseChannel(data, StreamCallback(completion, map: LightningApiTransformations.closeChannel))
        } else {
            completion(.failure(LndApiError.invalidInput))
        }
    }
    
    public func sendCoins(address: BitcoinAddress, amount: Satoshi, completion: @escaping (Result<String, LndApiError>) -> Void) {
        let data = LNDSendCoinsRequest(address: address, amount: amount).data()
        LndmobileSendCoins(data, StreamCallback(completion, map: LightningApiTransformations.sendCoins))
    }
    
    public func peers(completion: @escaping (Result<[Peer], LndApiError>) -> Void) {
        LndmobileListPeers(nil, StreamCallback(completion, map: LightningApiTransformations.peers))
    }
    
    public func decodePaymentRequest(_ paymentRequest: String, completion: @escaping (Result<PaymentRequest, LndApiError>) -> Void) {
        let data = LNDPayReqString(payReq: paymentRequest).data()
        LndmobileDecodePayReq(data, StreamCallback(completion, map: LightningApiTransformations.decodePaymentRequest(paymentRequest: paymentRequest)))
    }
    
    public func sendPayment(_ paymentRequest: PaymentRequest, amount: Satoshi?, completion: @escaping (Result<Payment, LndApiError>) -> Void) {
        let data = LNDSendRequest(paymentRequest: paymentRequest.raw, amount: amount).data()
        LndmobileSendPaymentSync(data, StreamCallback<LNDSendResponse, Payment>(completion, map: LightningApiTransformations.sendPayment(paymentRequest: paymentRequest, amount: amount)))
    }
    
    public func addInvoice(amount: Satoshi?, memo: String?, completion: @escaping (Result<String, LndApiError>) -> Void) {
        let data = LNDInvoice(amount: amount, memo: memo).data()
        LndmobileAddInvoice(data, StreamCallback(completion, map: LightningApiTransformations.addInvoice))
    }
    
    public func invoices(completion: @escaping (Result<[Invoice], LndApiError>) -> Void) {
        let data = LNDListInvoiceRequest(reversed: true).data()
        LndmobileListInvoices(data, StreamCallback(completion, map: LightningApiTransformations.invoices))
    }
    
    public func subscribeChannelGraph(completion: @escaping (Result<GraphTopologyUpdate, LndApiError>) -> Void) {
        LndmobileSubscribeChannelGraph(nil, StreamCallback(completion, map: LightningApiTransformations.subscribeChannelGraph))
    }
    
    public func subscribeInvoices(completion: @escaping (Result<Invoice, LndApiError>) -> Void) {
        LndmobileSubscribeInvoices(nil, StreamCallback(completion, map: LightningApiTransformations.subscribeInvoices))
    }
}

#endif
